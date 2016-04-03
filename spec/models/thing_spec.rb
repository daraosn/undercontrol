describe Thing do

  before(:each) do
    @user = create :user
    @thing = Thing.new(name: 'Test Thing', user: @user)
  end

  subject { @thing }

  it "has default values for alarm" do
    expect(@thing.alarm_min).to eq 0
    expect(@thing.alarm_max).to eq 0
    expect(@thing.alarm_threshold).to eq 0
  end

  describe "#check_alarm" do
    it "should not trigger alarm if alarm's action, threshold or range are invalid" do
      expect(@thing.check_alarm).to eq false
    end

    describe "limits" do
      before(:each) do
        @thing.update alarm_min: 10, alarm_max: 20, alarm_threshold: 3, alarm_action: {type: :test}.to_json
      end

      it "should trigger if maximum is exceeded" do
        expect {
          @thing.measurements << Measurement.new(value: 20)
        }.to_not change { @thing.alarm_triggered }

        expect {
          @thing.measurements << Measurement.new(value: 21)
          @thing.measurements << Measurement.new(value: 21)
        }.to_not change { @thing.alarm_triggered }

        expect {
          @thing.measurements << Measurement.new(value: 21)
        }.to change { @thing.alarm_triggered }
      end

      it "should trigger if new value is below minimum" do
        expect {
          @thing.measurements << Measurement.new(value: 10)
        }.to_not change { @thing.alarm_triggered }

        expect {
          @thing.measurements << Measurement.new(value: 9)
          @thing.measurements << Measurement.new(value: 9)
        }.to_not change { @thing.alarm_triggered }

        expect {
          @thing.measurements << Measurement.new(value: 9)
        }.to change { @thing.alarm_triggered }
      end

      it "should untrigger alarm if values are in range" do
        @thing.measurements << Measurement.new(value: 9)
        @thing.measurements << Measurement.new(value: 9)
        @thing.measurements << Measurement.new(value: 9)

        expect {
          @thing.measurements << Measurement.new(value: 10)
          @thing.measurements << Measurement.new(value: 10)
        }.to_not change { @thing.alarm_triggered }

        expect {
          @thing.measurements << Measurement.new(value: 10)
        }.to change { @thing.alarm_triggered }

      end

    end

  end

end
