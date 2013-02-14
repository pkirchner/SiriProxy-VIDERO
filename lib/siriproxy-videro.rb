# -*- encoding: utf-8 -*-

require 'cora'
require 'siri_objects'
require 'pp'
require 'net/http'

class SiriProxy::Plugin::Videro < SiriProxy::Plugin
  def ask_for_playername
    player = ask("Welchen Player möchten Sie benutzen?")
    return player.gsub(/\s/,"")
  end
  
  def ask_for_channel
    channel = ask("Welcher Kanal?")
    return channel.strip
  end
  
  def ask_for_programm
    programm = ask("Welches Programm?")
    return programm.strip
  end
  
  def ask_for_command
    command = ask("Was kann ich für Sie tun?")
    return command.strip
  end
  
  def initialize(config)
    
  end

  #get the user's location and display it in the logs
  #filters are still in their early stages. Their interface may be modified
  filter "SetRequestOrigin", direction: :from_iphone do |object|
    puts "[Info - User Location] lat: #{object["properties"]["latitude"]}, long: #{object["properties"]["longitude"]}"

    #Note about returns from filters:
    # - Return false to stop the object from being forwarded
    # - Return a Hash to substitute or update the object
    # - Return nil (or anything not a Hash or false) to have the object forwarded (along with any
    #    modifications made to it)
  end
  
  def videro_stop(player)
    http = Net::HTTP.new(player, 8000)
    http.get("/playlist/stop")
    say "Player " + player + " wurde gestoppt."
  end
  
  def videro_next(player)
    http = Net::HTTP.new(player, 8000)
    http.get("/playlist/next")
    say "Player " + player + " spielt den nächsten Beitrag."
  end
  
  def videro_previous(player)
    http = Net::HTTP.new(player, 8000)
    http.get("/playlist/previous")
    say "Player " + player + " spielt den vorherigen Beitrag."
  end
  
  def videro_play(player, programm, kanal)
    say "Auf dem Player '"+player+"' wird nun '"+programm+"' aus dem Kanal '"+kanal+"' gestartet."
    path = URI::encode("/playlist/playByPath/[\""+kanal+"\",\""+ programm+ "\"]")
    http = Net::HTTP.new(player, 8000)
    http.get(path)
  end
  
  listen_for /Steuer mein VIDERO /i do
    
    say "Willkommen im Videro Menü"
    say "Folgenden Befehle stehen Ihnen zur Auswahl :", spoken: ""
    say "- Abspielen", spoken: ""
    say "- Weiter", spoken: ""
    say "- Abbruch", spoken: ""
    say "- Stopp", spoken: ""
    
    while true
      case ask_for_command
      when "Stopp"
        videro_stop(ask_for_playername)
      when "Weiter"
        videro_next(ask_for_playername)
      when "Zurück"
        videro_previous(ask_for_playername)
      when "Abspielen"
        videro_play(ask_for_playername,ask_for_channel, ask_for_programm)
      when "Abbruch"
      else
        say "Ich habe das Kommando leider nicht verstanden, gültige Kommandos sind: Abspielen, Stopp, Weiter, Zurück und Abbruch."
        redo
      end
      break
    end
    request_completed
  end
end
