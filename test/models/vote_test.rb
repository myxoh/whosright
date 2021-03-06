require 'test_helper'

class VoteTest < ActiveSupport::TestCase
  setup do
    @user=users(:one)
    @discussion=discussions(:one)
    @position=positions(:one)
    @votes=[]
    @votes[0]=Vote.new(positive:true,user:@user,votable:@discussion)
    @votes[1]=Vote.new(positive:true,user:@user,votable:@position)
  end
  
  def get_vote(i)
    @vote=@votes[i]
  end
 
  
  def remove_param_test(param, vote = @votes[0])
    global_remove_param_test(param, vote)
  end
  
  test "Valid" do
    assert @votes[0].valid?
    assert @votes[1].valid?
  end
  
  test "Validators:" do
    remove_param_test("positive")
    remove_param_test("user")
    remove_param_test("votable")
    remove_param_test("votable", @votes[1]) #Shouldn't make any difference.
  end
  
  def assert_vote_worked(difference, votable, old_score)
    votable.reload
    assert_equal(votable.score-old_score, difference)
    votable
  end
  
  def casted_method_assertion(hash)
    vote=Vote.find_by(hash)
    assert_equal Vote.casted(hash), vote
    assert_equal Vote.casted?(hash), !vote.nil?
    assert_equal Vote.casted_up?(hash), vote.try(:positive)
    assert_equal Vote.casted_down?(hash), !vote.nil?&&!vote.try(:positive)
  end
  
  #Tests for both votable elements
  2.times do |i|

    test "Voting"+i.to_s do
      #Is this necessary after having already tested in the controllers?? 
      get_vote i
      votable=@vote.votable
      initial_score=votable.score
      
      positive_params={positive:true,user:@user,votable:votable}
      negative_params={positive:false,user:@user,votable:votable}
      
      @vote.positive=true
      
      @vote.save

      votable=assert_vote_worked(1, votable, initial_score)
      @vote.destroy
      votable=assert_vote_worked(0, votable, initial_score)
      @vote=Vote.create(positive_params)
      votable=assert_vote_worked(1, votable, initial_score)
      @vote.update(negative_params)
      votable=assert_vote_worked(-1, votable, initial_score)     
      @vote.destroy
      votable=assert_vote_worked(0, votable, initial_score)
      
    end
    
    
    test "casted methods"+i.to_s do
      get_vote i
      votable=@vote.votable
      hash={votable:votable,user:User.first}
      casted_method_assertion hash
      hash={votable:votable,user:User.second}
      casted_method_assertion hash
      hash={votable:nil,user:User.first}
      casted_method_assertion hash
      hash={votable:votable,user:nil}
      casted_method_assertion hash
      hash={votable:nil,user:nil}
      casted_method_assertion hash
    end
    
    test "Validate CRUD method"+i.to_s do
      get_vote i

      @vote.save
      votable=@vote.votable
      
      #Destroy
      assert_difference('Vote.count', -1) do #Logic - Vote RE-CASTED therefore the vote is DESTROYED
        Vote.crud(@user,votable,true) 
      end
      
      #Create
      assert_difference('Vote.count', +1) do #Logic - Vote RE-CASTED therefore the vote is RE-CREATED
        @vote=Vote.crud(@user,votable,true)
        assert_equal @votes[0].class.name, @vote.class.name #Make sure I still got a Vote object after the crud operation to avoid wierdness in the following tests
      end
      
      #Update
      assert_difference('Vote.count', 0) do #Logic - Vote Positive param changed. therefore vote is update
        Vote.crud(@user,votable,false)
        @vote.reload
        assert_not @vote.positive #As I passed the negative params I'm now expecting this vote to be updated and now have negative.
      end
    end
 end
end
