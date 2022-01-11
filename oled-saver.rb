module OLED_SAVER
  private
  def self.user_time
    time = ARGV[0].to_i
    time = nil if time == 0
    time
  end

  MIN = self.user_time || 5
  SEC = MIN * 60
  @dimmed = false
  puts "I will check on your mouse status each #{MIN} mints"
  
  public
  def self.run
    xp = yp = 0

    while true do
      x, y = `xdotool getmouselocation --shell`[/X=(\d+)\nY=(\d+)/].lines.map do |v| v[/.=(\d+)/, 1].to_i end
      if xp == x and yp == y
        `xrandr --output DP-4 --brightness 0.0`
        @dimmed = true
      else
        (@dimmed = false; `xrandr --output DP-4 --brightness 1.0`) if @dimmed == true
        xp, yp = x, y
        sleep(SEC)
      end
    end
  end
end

OLED_SAVER.run
