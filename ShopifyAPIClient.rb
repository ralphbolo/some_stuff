class ShopifyAPIClient
  
  # attr_reader :shop_id
  # SECRET_API_KEY = "asdasdasQWRESFSDFVSDFASDFSADFASDF123123ASDASD$%$%"
   
  # def set_shop_id(shop_Id)
  #   @shop_id = shop_Id
  # end
  attr_accessor :shop_id
  SECRET_API_KEY = ENV['api_key']
 
  def orders
    params = authenticate
    orders_json = some_http_library.get("https://www.shopify.this.is.a.sample.com/#{shop_id}/orders", params)
    return JSON.parse(orders_json)
  end
 
  def products
    params = authenticate
    products_json = some_http_library.get("https://www.shopify.this.is.a.sample.com/#{shop_id}/products", params)
    return JSON.parse(products_json)
  end
 
  def product(id)
    params = authenticate
    product_json = some_http_library.get("https://www.shopify.this.is.a.sample.com/#{shop_id}/products/#{id}", params)
    return JSON.parse(product_json)
  end

  def authenticate
    params = Hash.new
    params[:basic_auth] = {username: SECRET_API_KEY, password: ''} #username could also be wrong, im not sure
    return params
  end
end
