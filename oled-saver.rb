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
    if ARGV[argc] == '-s'
      argc 1
      while ARGV.size >= argc + 1
        tmp_screen = ARGV[argc]
        if `xrandr | grep -o '#{tmp_screen} connected'`.empty?
          break
        else
          screen ? screen = "#{screen} #{tmp_screen}" : screen = tmp_screen
        end
        argc argc + 1
      end
    end 
    screen
  end

  def self.user_time
    time = ARGV[argc].to_f
    time = false if time == 0
    time
  end

  SCREEN = (self.user_screen || 'DP-4').split
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
        if @dimmed == false
          SCREEN.size.times.with_index do |index|
            `xrandr --output #{SCREEN[index]} --brightness 0.0`
          end
          @dimmed = true 
        end
      else
        SCREEN.size.times.with_index do |index|
          @dimmed = false; `xrandr --output #{SCREEN[index]} --brightness 1.0`
        end if @dimmed == true
        xp, yp = x, y
        sleep SEC
      end
    end
  end
end

OLED_SAVER.run
