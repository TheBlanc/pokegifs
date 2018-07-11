class PokemonController < ApplicationController

  def show
    name = poke_body["name"]
    id = poke_body["id"]

    unless !name
      random_num = rand(giphy_body["data"].length)
      gif_url = giphy_body["data"][random_num]["embed_url"]
      gif_id = giphy_body["data"][random_num]["id"]
    end

    if !name && !gif_url
      render file: 'public/404.html', layout: false, status: 404
    end

      @id      = id
      @name    = name
      @types   = get_types(poke_body)
      @gif_url = gif_url
      @gif_id = gif_id


      respond_to do |format|
        format.html
        
        format.json do
          render json: { id:    @id,
                         name:  @name,
                         types: @types,
                         gif:   @gif_url }
        end
      end

  end


  private

  def poke_body
    poke_res = HTTParty.get("http://pokeapi.co/api/v2/pokemon/#{params[:id]}/")
    return JSON.parse(poke_res.body)
  end

  def giphy_body
    giphy_key = ENV['GIPHY_KEY']
    name = poke_body["name"]
    giphy_res = HTTParty.get("https://api.giphy.com/v1/gifs/search?api_key=#{giphy_key}&q=#{name}")
    return JSON.parse(giphy_res.body)
  end

  def get_types(body)
    types = []
    body["types"].each do |obj|
        types.push(obj["type"]["name"])
    end
    return types
  end

end
