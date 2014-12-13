tmux_conf_location = ENV["HOME"] + '/.tmux.conf'

File.write(tmux_conf_location, "") if File.file?(tmux_conf_location) == false
standard_tmux_conf = File.read(tmux_conf_location)

if standard_tmux_conf.match(/set -g status-bg/) == false
    tmux_conf_with_status_bg = standard_tmux_conf + "\nset -g status-bg green"
    File.open(tmux_conf_location, "w") {|file| file.puts tmux_conf_with_status_bg}
    stnadard_tmux_conf = tmux_conf_with_status_bg
end

standard_status_bg = standard_tmux_conf.match(/set -g status-bg (.*)/)[1]
standard_status_bg == "red" ? alert_status_bg = "yellow" : alert_status_bg = "red"
alert_tmux_conf = standard_tmux_conf.gsub(/(?<=set -g status-bg ).*/, %{#{alert_status_bg}\0})

4.times do
    2.times do
        print "\a"
        File.write(tmux_conf_location, alert_tmux_conf)
        `tmux source-file $HOME/.tmux.conf`
        sleep(0.125)
        File.write(tmux_conf_location, standard_tmux_conf)
        `tmux source-file $HOME/.tmux.conf`
        sleep(0.125)
    end
    sleep(0.5)
end
