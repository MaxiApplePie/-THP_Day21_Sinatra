class Gossip
  attr_reader :content, :author, :id

  def initialize(content, author, id = 0)
    @content = content # qui est un string
    @author = author # qui est aussi un string
    @id = id # qui est un Integer
    if id == 0
      @id = self.class.get_last_id_plus_one
    end
  end

  def save
    #    CSV.open("./db/gossip.csv", "ab") do |csv|
    #     csv << ["Mon super auteur", "Ma super description"]
    CSV.open("./db/gossip.csv", "ab") do |csv|
      csv << [@id, @content, @author]
    end
  end

  def self.update(id_to_update, author, content)
    puts author
    puts "mmm" * 10
    #     Gossip.update(params["id"], params["gossip_author"], params["gossip_content"])
    CSV.foreach("./db/gossip.csv", headers: false) do |row|
      CSV.open("./db/gossip.csv.tmp", "a") do |f2|
        if (id_to_update != row[0])
          f2 << [row[0], row[1], row[2]]
        else
          f2 << [id_to_update, author, content]
        end
      end
    end
    system("cp ./db/gossip.csv.tmp ./db/gossip.csv")
    system("rm ./db/gossip.csv.tmp")
  end

  def self.get_last_id_plus_one
    return CSV.read("./db/gossip.csv").last[0].to_i + 1
  end

  def self.find(id_to_find) #Extrait le gossip par id
    CSV.foreach("./db/gossip.csv", headers: false) do |row|
      if (row[0].to_i == id_to_find.to_i)
        @gossip_found = Gossip.new(row[1], row[2], row[0])
      end
    end
    return @gossip_found
  end

  def self.destroy(text_gossip)
    CSV.foreach("./db/gossip.csv", headers: false) do |row|
      gossip_trf = Gossip.new(row[1], row[2], row[0])
      CSV.open("./db/gossip.csv.tmp", "a") do |f2|
        if (gossip_trf.content != text_gossip)
          f2 << [gossip_trf.id, gossip_trf.content, gossip_trf.author]
        end
      end
    end
    system("cp ./db/gossip.csv.tmp ./db/gossip.csv")
    system("rm ./db/gossip.csv.tmp")
  end

  def self.all
    all_gossips = Array.new
    CSV.foreach("./db/gossip.csv", "r") do |row|
      gossip_provisoire = Gossip.new(row[1], row[2], row[0])
      puts gossip_provisoire.inspect
      all_gossips << gossip_provisoire
    end
    return all_gossips
  end
end
