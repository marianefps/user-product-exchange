class ProductExchangeService
  attr_accessor :errors
  def initialize(requester, params_exchange)
    @requester = requester
    @products_requester = params_exchange[:products_requester].map do |product|
      {product: product[:product], quantity: product[:quantity].to_i}
    end

    @receiver = User.find params_exchange[:receiver]
    @products_receiver = params_exchange[:products_receiver].map do |product|
      {product: product[:product], quantity: product[:quantity].to_i}
    end

    @errors = []
  end

  def save
    return false unless valid?

    Inventory.transaction do
      @products_requester.each do |product|
        inventory_requester = @requester.inventories.find_by product: product[:product]
        inventory_requester.quantity -= product[:quantity]
        inventory_requester.quantity.zero? ? inventory_requester.destroy! : inventory_requester.save!

        inventory_receiver = @receiver.inventories.find_or_initialize_by product: product[:product]
        inventory_receiver.quantity += product[:quantity]
        inventory_receiver.save!
      end

      @products_receiver.each do |product|
        inventory_receiver = @receiver.inventories.find_by product: product[:product]
        inventory_receiver.quantity -= product[:quantity]
        inventory_receiver.quantity.zero? ? inventory_receiver.destroy! : inventory_receiver.save!

        inventory_requester = @requester.inventories.find_or_initialize_by product: product[:product]
        inventory_requester.quantity += product[:quantity]
        inventory_requester.save!
      end
    end
    true
  end

  def valid?
    validade_users_vacation

    return false if @errors.any?
    validate_requester_kind_of_product
    validate_receiver_kind_of_product

    return false if @errors.any?

    validate_requester_has_product
    validate_receiver_has_product
    return false if @errors.any?

    validate_amount_exchange

    @errors.empty?
  end

  private

  def validade_users_vacation
    @errors << 'Inventory is unavailable for requester' if @requester.on_vacation?
    @errors << 'Inventory is unavailable for receiver' if @receiver.on_vacation?

  end

  def validate_requester_kind_of_product
    valid_kinds = @products_requester.map do |product|
      Inventory::PRODUCTS.key? product[:product]
    end
    @errors << "This requester kind of product does not exist" unless valid_kinds.all?
  end

  def validate_receiver_kind_of_product
    valid_kinds = @products_receiver.map do |product|
      Inventory::PRODUCTS.key? product[:product]
    end
    @errors << "This receiver kind of product does not exist" unless valid_kinds.all?
  end



  def validate_requester_has_product
    if @products_requester.empty?
      @errors << 'Empty field for requester to exchange products'
      return
    end

    products = @products_requester.map { |p| p[:product] }

    requester_products = @requester.inventories.where(product: products)

    if requester_products.blank?
      @errors << "Requester doesn't have the products"
      return
    end
    enough_exchanges = requester_products.map do |requester_product|
      qtd_exchange = @products_requester.find { |p| p[:product] == requester_product.product }[:quantity]
      qtd_exchange <= requester_product.quantity
    end

    @errors << "Requester doesn't have enough quantity of products" unless enough_exchanges.all? # false
  end

  def validate_receiver_has_product
    if @products_receiver.empty?
      @errors << 'Empty field for receiver to exchange products'
      return
    end

    products = @products_receiver.map { |p| p[:product] }

    receiver_products = @receiver.inventories.where(product: products)

    if receiver_products.blank?
      @errors << "Receiver doesn't have the products"
      return
    end

    enough_exchanges = receiver_products.map do |receiver_product|
      qtd_exchange = @products_receiver.find { |p| p[:product] == receiver_product.product }[:quantity]
      qtd_exchange <= receiver_product.quantity
    end

    @errors << "Receiver doesn't have enough quantity of products" unless enough_exchanges.all? # false
  end

  def validate_amount_exchange
    requester_amount = @products_requester.map do |product|
      Inventory::PRODUCTS[product[:product]] * product[:quantity]
    end.sum

    receiver_amount = @products_receiver.map do |product|
      Inventory::PRODUCTS[product[:product]] * product[:quantity]
    end.sum

     @errors << "Values amount exchange are different" if requester_amount != receiver_amount
  end
end
