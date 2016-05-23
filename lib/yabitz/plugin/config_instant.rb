# -*- coding: utf-8 -*-

module Yabitz::Plugin
  module InstantConfig
    def self.plugin_type
      :config
    end
    def self.plugin_priority
      1
    end

    def self.extra_load_path(env)
      if env == :production
        ['~/Documents/Stratum']
      else
        ['~/Documents/Stratum']
      end
    end

    DB_PARAMS = [:server, :user, :pass, :name, :port, :sock]

    CONFIG_SET = {
      :database => {
        :server => ENV["YABITZ_DBHOST"] || 'localhost',
        :user => ENV["YABITZ_DBUSER"] || 'root',
        :pass => ENV["YABITZ_DBPASS"] || nil,
        :name => ENV["YABITZ_DBNAME"] || 'yabitz',
        :port => ENV["YABITZ_DBPORT"] || nil,
        :sock => ENV["YABITZ_DBSOCK"] || nil,
      },
    }

    def self.dbparams(env)
      DB_PARAMS.map{|sym| CONFIG_SET[:database][sym]}
    end
  end
end
