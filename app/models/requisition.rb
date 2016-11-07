class Requisition < ApplicationRecord
    #enum loc: [:holsworthy, :victoria, :hampstead, :angelsea]
  after_update :create_attached_order, on: :update
  has_one :order

  def to_s 
  	"Requisition \##{id}"
  end

  def create_attached_order
  	if status == 'Approved' 
  		self.create_order({
  			:status => 'Pending'
  		})
  	end
  end	
end

