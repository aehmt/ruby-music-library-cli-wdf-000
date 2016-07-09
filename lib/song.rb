require 'pry'
require_relative '../lib/concerns/findable'

class Song

  extend Concerns::Findable

  @@all = []
  
  attr_accessor :name
  attr_reader :artist, :genre

  def initialize(name, artist = nil, genre = nil)
    @name = name
    self.artist = artist if artist
    self.genre = genre if genre
  end

  def artist=(artist)
    @artist = artist
    artist.add_song(self)
  end

  def genre=(genre)
    @genre = genre
    genre.songs << self unless genre.songs.include?(self)    
  end
  
  def self.all
    @@all
  end

  def self.destroy_all
    all.clear
  end

  def save
    @@all << self
    self
  end

  def self.create(song_name, artist = nil, genre = nil)
    new(song_name, artist, genre).save
  end

  def self.new_from_filename(file_name)
    # binding.pry
    split_name = file_name.split(" - ")
    song_name = split_name[1]
    artist_name = split_name[0]
    genre_name = split_name[2].gsub(".mp3", "")

    # binding.pry

    new_artist = Artist.find_by_name(artist_name) ||  Artist.new(artist_name)
    new_genre = Genre.find_by_name(genre_name) || Genre.new(genre_name)

      new_song = self.new(song_name)
      new_song.artist = new_artist
      new_song.genre = new_genre
      new_song
  end

  def self.create_from_filename(file_name)
    split_name = file_name.split(" - ")
    song_name = split_name[1]
    artist_name = split_name[0]
    genre_name = split_name[2].gsub(".mp3", "")

    new_artist = Artist.find_or_create_by_name(artist_name) 
    new_genre = Genre.find_or_create_by_name(genre_name) 
  
    self.create(song_name, new_artist, new_genre)
  end
  
end



