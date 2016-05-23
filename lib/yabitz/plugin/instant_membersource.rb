# -*- coding: utf-8 -*-

require 'digest/sha1'
require 'mysql2-cs-bind'

module Yabitz::Plugin
  module InstantMemberHandler
    def self.plugin_type
      [:auth, :member]
    end
    def self.plugin_priority
      1
    end

    DB_HOSTNAME = ENV["YABITZ_MEMBER_DBHOST"] || "localhost"
    DB_USERNAME = ENV["YABITZ_MEMBER_DBUSER"] || "root"
    DB_PASSWORD = ENV["YABITZ_MEMBER_DBPASS"] || nil
    DATABASE_NAME = ENV["YABITZ_MEMBER_DBNAME"] || "yabitz_member_source"
    TABLE_NAME = "list"
    def self.query(sql, *args)
      result = []
      begin
        client = Mysql2::Client.new(:host => DB_HOSTNAME, :username => DB_USERNAME, :password => DB_PASSWORD, :database => DATABASE_NAME)
        client.xquery(sql, *args).each(:as => :array) {|r|
          result.push(r.map{|v| v.respond_to?(:encode) ? v.encode('utf-8') : v})
        }
        result
      rescue Mysql2::Error => e
        if e.message =~ /^Unknown database/
          return []
        end
        raise
      end
    end

    def self.authenticate(username, password, sourceip=nil)
      results = self.query(
                           "SELECT fullname,name FROM #{TABLE_NAME} WHERE name=? AND passhash=?",
                           username, Digest::SHA1.hexdigest(password)
                           )
      if results.size != 1
        return nil
      end
      results.first.first
    end

    MEMBERLIST_FIELDS = [:fullname, :badge, :position]

    def self.find_by_fullname_list(fullnames)
      cond = (['fullname=?'] * fullnames.size).join(' OR ')
      results = self.query("SELECT #{MEMBERLIST_FIELDS.map(&:to_s).join(',')} FROM #{TABLE_NAME} WHERE #{cond}", *fullnames)

      fullnames.map{|fn| results.select{|ary| ary.first == fn}.first}.compact
    end

    def self.find_by_badge_list(badges)
      cond = (['badge=?'] * badges.size).join(' OR ')
      results = self.query("SELECT #{MEMBERLIST_FIELDS.map(&:to_s).join(',')} FROM #{TABLE_NAME} WHERE #{cond}", *badges)

      badges.map{|bd| results.select{|ary| ary[1] == bd}.first}.compact
    end

    def self.find_by_fullname_and_badge_list(pairs)
      cond = (['(fullname=? AND badge=?)'] * pairs.size).join(' OR ')
      results = self.query("SELECT #{MEMBERLIST_FIELDS.map(&:to_s).join(',')} FROM #{TABLE_NAME} WHERE #{cond}", *(pairs.flatten))

      pairs.map{|fn,bd| results.select{|ary| ary[0] == fn and ary[1] == bd}.first}.compact
    end

    def self.convert(values)
      Hash[*([MEMBERLIST_FIELDS, values].transpose)]
    end
  end
end
