#!/usr/bin/env ruby

module OLED_SAVER
  private
  @argc = 0

  def self.argc argc = @argc
    @argc = argc
  end

  # This works as we only have two arguments to specify:
  # [-s screen] [mints]
  def self.user_screen
    screen = false
    if ARGV[argc] == '-s' and ARGV.size >= 2
      argc 2  
      tmp_screen = ARGV[1]
      if `xrandr | grep -o '#{tmp_screen} connected'`.empty?
        warn "Specified screen is not connected (running defaults)"
      else
        screen = tmp_screen
      end
    end
    screen
  end

  def self.user_time
    time = ARGV[argc].to_f
    time = false if time == 0
    time
  end

  SCREEN = self.user_screen || 'DP-4'
  MIN = self.user_time || 5
  SEC = MIN * 60
  @dimmed = false
  puts "Targeted screen: #{SCREEN}"
  puts "Delta time: #{MIN} mints"
  
  public
  def self.run
    trap 'INT' do puts ''; exit 0 end
    xp = yp = 0

    while true do
      x, y = `xdotool getmouselocation --shell`[/X=(\d+)\nY=(\d+)/].lines.map do |v| v[/.=(\d+)/, 1].to_i end
      if xp == x and yp == y
        (`xrandr --output #{SCREEN} --brightness 0.0`
         @dimmed = true) if @dimmed == false
      else
        (@dimmed = false; `xrandr --output #{SCREEN} --brightness 1.0`) if @dimmed == true
        xp, yp = x, y
        sleep SEC
      end
    end
  end
end

OLED_SAVER.run
