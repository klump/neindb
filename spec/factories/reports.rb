FactoryGirl.define do
  factory :report do
    status :success
    starttime { 5.minutes.ago }
    endtime { Time.now }
    data {
      {
        cpuinfo: {
          output: "Intel CPU",
          error: "",
          exitcode: 0
        },
        dmesg: {
          output: "Lots of output",
          error: "",
          exitcode: 0
        }
      }
    }
    user { FactoryGirl.create(:user) }
  end
  factory :report_failed, class: Report  do
    status :failure
    starttime { 5.minutes.ago }
    endtime { 2.minutes.ago }
    data {
      {
        errors: "Could not find a valid ID for the asset"
      }
    }
    user { FactoryGirl.create(:user) }
  end
  factory :report_running, class: Report do
    status :running
    starttime { 1.minutes.ago }
    endtime nil
    data nil
    user { FactoryGirl.create(:user) }
  end

  # invalid report to test validations
  factory :report_invalid, class: Report do
    status :something_invalid
    starttime "invalid"
    endtime "invalid"
    data [1, 2, 3, 4]
    user { FactoryGirl.create(:user) }
  end
end
