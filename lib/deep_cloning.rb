# DeepCloning
#
# clones an ActiveRecord model. 
# if passed the :include option, it will deep clone the given associations
# if passed the :except option, it won't clone the given attributes
#
# === Usage:
# 
# === Cloning a model without an attribute
#    pirate.clone!(:except => :name)
#  
# === Cloning a model without multiple attributes
#    pirate.clone!(:except => [:name, :nick_name])
# === Cloning one single association
#    pirate.clone!(:include => :mateys)
# 
# === Cloning multiple associations
#    pirate.clone!(:include => [:mateys, :treasures])
# 
# === Cloning really deep
#    pirate.clone!(:include => {:treasures => :gold_pieces})
# 
# === Cloning really deep with multiple associations
#    pirate.clone!(:include => [:mateys, {:treasures => :gold_pieces}])
# 
# === The forcing of certain attributes
#     pirate.clone!(:force => {
#          :name => "Overridden by specifics below",
#          :pirate => {:name => "Señor Jack"},
#          :parrot => {:type => "eagle"}
#         }
#     )
# 
# === Re-Mapping of attributes and objects
# Handy for mutating objects that may have the same parent class.. or are just really similar
# 
#     pirate.clone!(:remap => {
#          :pirate => [:red_coat, {:pirate_attr => :red_cout_attr}],
#          :parrot => [:ostrich. {:parrot_attr => :ostrich_attr}]
#         }
#     )
# 
#
# 
# Forked From at this: https://github.com/openminds/deep_cloning/
# but it doesn't handle foreign_keys correctly
#
# preforms a recursive deep_copy / clone on an object, saving referenced models as the "stack" unfolds
module DeepCloning  
  REMAP_INDEX_OF_NEW_OBJECT = 0
  REMAP_INDEX_OF_ATTRIBUTES_MAP = 1
  # @param [Hash] options 
  # defaults = {:except => [:updated_at, :created_at, :id], 
  #            :include => [], 
  #            :force => {},
  #            :remap => {}}
  #   :udated_at, :created_at and :id will always be in the exclude array, 
  #       even if a :except is passed through the formal parameter options
  #
  # @return [ActiveRecord::Base] the Object that was cloned
  def clone!(options = {})
    defaults = {:except => [:updated_at, :created_at, :id], 
                :include => [], 
                :force => {},
                :remap => {}}

    exceptions = Array(options[:except])
    exceptions.concat(defaults[:except]) if options[:except]
    exceptions.uniq!
    
    options = defaults.merge(options)
    # attributes not to clone at all
    skip_attributes = options[:except] or false
    # list of associations to copy
    associations = options[:include] or false
    # list of forced attributes to set
    forced = options[:force] or false
    # list of models an attributes to map to other models and attributes
    remapped = options[:remap] or false
    @remap_for_object = remapped[self.class.to_s.underscore.to_sym]
    
    kopy = nil
    if (not remapped or remapped.nil? or remapped.empty?)
      # doesn't save, only copies self's attributes
      kopy = self.clone
    else
      if (not @remap_for_object) or (@remap_for_object.size != 2)
        raise "Wrong number of parameters for remaped object: #{self.class.to_s}"
      end
      
      name_of_object_to_map_to = @remap_for_object[REMAP_INDEX_OF_NEW_OBJECT]
      kopy = name_of_object_to_map_to.to_s.classify.constantize.send(:new)
      
      # start copying attributes, taking into consideration, the possibility of 
      #   remapped attributes
      self.attributes.each do |attribute, value|
        # check if current attribute is being re-mapped
        attribute_to_set = get_remapped_attribute_for(attribute)
        attribute_to_set = attribute if attribute_to_set.nil?
        begin
          if (not Array(skip_attributes).include?(attribute_to_set))
            kopy.send("#{attribute_to_set}=", value) 
          else
            # database default
            kopy.send("#{attribute_to_set}=", attributes_from_column_definition[attribute.to_s])
          end
        rescue
          # kopy.class probably doesn't have that attribute
        end
      end
    end

    # add current class to exclusions to prevent infinite loop
    our_foreign_key = self.class.to_s.foreign_key
    exceptions << our_foreign_key

    if kopy.respond_to?("#{options[:previous_version_attr]}=")
      kopy.send("#{options[:previous_version_attr]}=", self)
    end
    
    Array(skip_attributes).each { |attribute|
      # attributes_from_column_definition is deprecated in rails > 2.3.8
      begin
        kopy[attribute] = attributes_from_column_definition[attribute.to_s]
      rescue
        # kopy.class doesn't have attribute
      end
    } if skip_attributes

    # Force attributes
    class_name_as_symbol = kopy.class.to_s.underscore.to_sym
    if forced
      general_attr = forced.map { |k, v| if (!v.is_a?(Hash)) then k end }.compact
      specific_attr = forced.map { |k, v| if (v.is_a?(Hash)) then k end }.compact
        
      general_attr.each do |attribute|
        begin
          kopy.send("#{get_remapped_attribute_for(attribute) or attribute}=", forced[attribute])
        rescue
          # do nothing, because not every model and its children are 
          #    going to have the  same attributes
        end
      end

      specific_attr.each do |attribute|
        if attribute == class_name_as_symbol
          forced_attribute_map = forced[class_name_as_symbol]
          forced_attribute_map.each do |attribute, value|
            kopy.send("#{get_remapped_attribute_for(attribute) or attribute}=", value)
          end
        end
      end
    end
    # save before we need self's id for has_many / has_one relationships    
    kopy.save_with_validation(false)
    
    if associations      
      Array(associations).each do |association, deep_associations|        
        if (association.kind_of? Hash)
          deep_associations = association[association.keys.first]
          association = association.keys.first
        end
        
        association_symbol = association.to_sym
        # add our ID as a forced attribute for the nested objects
        if !forced
          forced = {}
        end
        if !forced[association_symbol]
          forced[association_symbol] = {}
        end
        forced[association_symbol][our_foreign_key] = kopy[:id]
        forced[our_foreign_key] = kopy[:id]
        
        options[:force] = forced
        options.merge!({:include => deep_associations.blank? ? {} : deep_associations})
        options[:except].uniq!
        
        require "awesome_print"
        current_association = get_remapped_attribute_for(association) or nil
        current_association = association if (not current_association)
        
        reflected_association = self.class.reflect_on_association(association)
        next if reflected_association.nil?
        cloned_object = case reflected_association.macro
                        when :belongs_to, :has_one
                          ref_object = self.send(association).clone!(options)
                          kopy.send("#{current_association}=", ref_object)
                          ref_object
                        when :has_many, :has_and_belongs_to_many
                          self.send(association).collect { |obj| 
                            ref_object = obj.clone!(options)
                            ref_object.send("#{our_foreign_key}=", kopy[:id]) if ref_object
                            ref_object
                          }
                        end
                                       
        kopy.send("#{current_association}=", cloned_object)
      end
    end

    kopy.save_with_validation(false)
    return kopy
  end
  
  def get_remapped_attribute_for(attribute)
    result = false
    if @remap_for_object
      attributes_map = @remap_for_object[REMAP_INDEX_OF_ATTRIBUTES_MAP]
      result = attributes_map[attribute.to_sym]
    end
    return result
  end
  
end
require "active_record"
ActiveRecord::Base.send(:include, DeepCloning)