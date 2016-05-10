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
  def v i
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
  
  def assert_vote_worked difference, votable
    old_score=votable.score
    votable.reload
    assert_equal(old_score-votable.score,difference)
    return votable
  end
  
  #Tests for both votable elements
  2.times do |i|

    test "Voting"+i.to_s do
      #Is this necessary after having already tested in the controllers?? 
      v i
      votable=@vote.votable
      
      positive_params={positive:true,user:@user,votable:votable}
      negatative_params={positive:false,user:@user,votable:votable}
      
      @vote.positive=true
      
      @vote.save
      votable=assert_vote_worked(1, votable)
      @vote.destroy
      votable=assert_vote_worked(-1, votable)
      @vote.create(positive_params)
      votable=assert_vote_worked(1, votable)
      @vote.update(negative_params)
      votable=assert_vote_worked(-2, votable)     
      @vote.destroy
      votable=assert_vote_worked(+1, votable)
      
    end
    
    test "Validate CRUD method"+i.to_s do
      v i

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
