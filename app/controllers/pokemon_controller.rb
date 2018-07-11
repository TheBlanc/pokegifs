class PokemonController < ApplicationController

  def show
    poke_res = HTTParty.get("http://pokeapi.co/api/v2/pokemon/#{params[:id]}/")
    poke_body = JSON.parse(poke_res.body)

    if poke_body["name"]

      giphy_key = ENV['GIPHY_KEY']
      giphy_res = HTTParty.get("https://api.giphy.com/v1/gifs/search?api_key=#{giphy_key}&q=#{poke_body["name"]}")
      giphy_body = JSON.parse(giphy_res.body)
      random_num = rand(giphy_body["data"].length)

      id      = poke_body["id"]
      name    = poke_body["name"]
      types   = get_types(poke_body)
      gif_url = giphy_body["data"][random_num]["url"]


      render json: { id:    id,
                     name:  name,
                     types: types,
                     gif:   gif_url }
    else
      render file: 'public/404.html', layout: false, status: 404
    end
  end


private

  def get_types(body)
    types = []
    body["types"].each do |obj|
        types.push(obj["type"]["name"])
    end
    return types
  end

end
