require "gossip"
require "csv"
#http://localhost:4567/gossips/new/

class ApplicationController < Sinatra::Base
  get "/" do
    erb :index, locals: { gossips: Gossip.all }
  end

  get "/gossips/new/" do
    erb :new_gossip
  end

  post "/gossips/new/" do
    Gossip.new(params["gossip_author"], params["gossip_content"]).save
    redirect "/"
  end

  get "/gossips/:id/" do
    Gossip_to_find = Gossip.find(params["id"])
    erb :show, locals: { gossip: Gossip_to_find } # OK !!!
  end

  get "/gossips/:id/edit/" do
    Gossip_to_update = Gossip.find(params["id"])
    erb :edit, locals: { gossip: Gossip_to_update }
  end

  post "/gossips/:id/update/" do
    Gossip.update(params["id"], params["gossip_author"], params["gossip_content"])
    redirect "/"
  end
end
