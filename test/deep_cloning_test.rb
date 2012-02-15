require File.dirname(__FILE__) + '/teststrap'
require 'parrot'
require 'matey'
require 'gold_piece'
require 'treasure'
require 'pirate'
require 'deep_cloning'

require 'ruby-debug'
context "Deep Cloning" do
  setup do
    @jack = Pirate.new(:name => "Jack Sparrow",
                       :nick_name => "Captain Jack")
    @polly = @jack.build_parrot(:name => 'Polly')
    @jack.mateys.build(:name => "John")
    @jack.treasures.build(:found_at => "Isla del Muerte")
    @jack.treasures.first.gold_pieces.build
    @jack.save
  end

  context "setting the :previous_version_attr" do
    setup do
      @jack.clone!(:include => :mateys,
                  :previous_version_attr => :parent)
    end

    should "set the :previous_version_attr to the thing being clone!d" do
      topic.parent == @jack
    end

    should "set the :previous_version_attr on all included associations" do
      topic.mateys.map(&:parent).to_set ==
        @jack.mateys.to_set
    end
  end

  context "excluding a single attribute" do
    setup do
      @jack.clone!(:except => :name)
    end

    should "not clonethat attribute" do
      topic.name
    end.equals(nil)
  end
 
  context "excluding multiple attributes" do
    setup do
      @jack.clone!(:except => [:name, :nick_name])
    end

    should "not cloneany of the attributes" do
      topic.attributes.slice(:name, :nick_name).any?
    end.equals(false)
  end 

  context "including one association" do
    setup do
      @jack.clone!(:include => :mateys)
    end

    should "have the same number of associated objects" do
      topic.mateys.size == @jack.mateys.size
    end
  end

  context "including more than one association" do
    setup do
      @jack.clone!(:include => [:mateys, :treasures])
    end

    should "have the same number of objects in each association" do
      topic.mateys.size    == @jack.mateys.size and
      topic.treasures.size == @jack.treasures.size
    end
  end

  context "deep association includes" do
    setup do
      clone= @jack.clone!(:include => {:treasures => :gold_pieces})
      clone.save && clone.reload
    end

    should "cloneall the way down" do
      topic.treasures.size   == @jack.treasures.size and
      topic.gold_pieces.size == @jack.gold_pieces.size
    end
  end
  
  context "multiple deep association includes" do
    setup do
      clone= @jack.clone!(:include => {:treasures => :gold_pieces, :mateys => {}})
      clone.save && clone.reload
    end

    should "cloneall listed associations" do
      topic.treasures.size   == @jack.treasures.size and
      topic.gold_pieces.size == @jack.gold_pieces.size and
      topic.mateys.size      == @jack.mateys.size
    end
  end

  context "multiple deep associations specified with an array" do
    setup do
      clone= @jack.clone!(:include => [{:treasures => :gold_pieces}, :mateys])
      clone.save && clone.reload
    end

    should "cloneall listed associations" do
      topic.treasures.size   == @jack.treasures.size and
      topic.gold_pieces.size == @jack.gold_pieces.size and
      topic.mateys.size      == @jack.mateys.size
    end
    
  end

  context "deep copying a has_one association" do
    setup do
      clone = @jack.clone!(:include => :parrot)
      clone.save && clone.reload
    end
    should "create a new object" do
      topic.parrot != @jack.parrot
    end 
  end
  
  context "forcing attributes" do
    setup do
      clone = @jack.clone!(:force => {:pirate => {:name => "new name"}})
    end
    
    should "have 'new name' as the name" do
      "new name" == topic.name
      topic.name != @jack.name
    end
  end
  
  context "force multiple attributes for multiple models" do
    setup do
      clone = @jack.clone!(:include => :parrot, 
                           :force => {:pirate => {:name => "new name"},
                                      :parrot => {:name => "parrot"}})
    end
    
    should "have name's changed from the original names" do
      "new name" == topic.name
      "parrot" == topic.parrot.name
      topic.name != @jack.name
      topic.parrot.name != @jack.parrot.name
    end
  end
  
  context "force attribute genericly" do
    setup do
      clone = @jack.clone!(:include => :parrot,
                           :force => {:name => "new name"})
    end
    
    should "have both names change from the original names" do
      "new name" == topic.name
      "new name" == topic.parrot.name
      topic.name != @jack.name
      topic.parrot.name != @jack.parrot.name
    end
  end
  
  context "forcing attributes that don't exist" do
    setup do
      clone = @jack.clone!(:include => :parrot,
                           :force => {:nick_name => "nick"})
    end
    
    should "not throw an error for an attribute that dosen't exist" do
      topic.parrot.name == @jack.parrot.name
    end
  end
  
  context "remap a pirate into a parrot" do
    setup do 
      clone = @jack.clone!(:remap => {
        :pirate => [:parrot, {}]
      })
    end
    
    should "be converted to a parrot from a pirate" do
      topic.name == @jack.name
      topic.is_a? Parrot
    end
  end
  
  context "remap attributes from model to model" do
    setup do
      clone = @jack.clone!(:remap => {
        :pirate => [:parrot, {:nick_name => :name}]
      })
    end
    
    should "have the pirate nick name as the parrot's name" do
      topic.name == @jack.nick_name
      topic.is_a? Parrot
    end
  end
  
  context "exclude attributes should still be excluded even if they are re-mapped" do
    setup do
      clone = @polly.clone!(
        :remap => {
          :parrot => [:pirate, {:name => :nick_name}]
        },
        :except => [:nick_name]
        )
    end
    
    should "not have a nick name" do
      topic.nick_name == nil # database default
      # Note: for nick_name attributes_from_column_definition returns nil... but the schema says 'no nickname'
      # so maybe this is an issue with the way the test environment is set up
    end
  end
end
