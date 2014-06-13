class Profile < ActiveRecord::Base

  ## relations

  belongs_to :user

  ## callbacks

  before_save :check_and_update_level

  ## class methods

  def self.initialize_profile_for! user
    @profile = Profile.new
    @profile.user = user
    @profile.title = Profile.title_for_level 1
    @profile.save!
  end

  def self.title_for_level lvl
    case lvl
    when 1
      "Początkujący Praktykant"
    when 10
      "Cierpliwy Czeladnik"
    when 20
      "Ambitny Adept"
    when 30
      "Wybitny Wyrobnik"
    when 40
      "Uczciwy Uczeń"
    when 100
      "Mądry Mistrz"
    else
      nil
    end
  end

  ## instance methods

  def xp_for_next_level
    xp = (Rules.base_xp_per_level * (level + 0.15 * (self.level - 1))).to_i
    return xp
  end

  def award_xp_for_task_completion

    # get base value
    awarded_xp = Rules.base_xp_bonus_for_task_completion

    # apply some randomness
    awarded_xp = (awarded_xp * rand(80..120) / 100).to_i

    # update profile
    self.xp_points += awarded_xp

    self.save!

  end


  ## private

  def check_and_update_level
    if self.xp_points > self.xp_for_next_level
      self.level += 1
    end
  end




end
