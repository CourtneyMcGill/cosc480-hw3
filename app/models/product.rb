class Product < ActiveRecord::Base

  has_attached_file :image, :styles=> {:medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/noimg.jpg"

  validates_attachment :image, :content_type => {:content_type => ["image/jpeg", "image/png", "image/gif"]}

  def age_range
        if self.minimum_age_appropriate == nil
                "0 and above"
        elsif self.maximum_age_appropriate == nil
                "#{self.minimum_age_appropriate} and above"
        elsif self.minimum_age_appropriate == self.maximum_age_appropriate
                "Age #{self.minimum_age_appropriate}"
        else
                "#{self.minimum_age_appropriate} to #{self.maximum_age_appropriate}"
        end
  end

  def age_appropriate?(age)
        if self.minimum_age_appropriate == nil #no age limits
                true
        elsif self.maximum_age_appropriate == nil
                if self.minimum_age_appropriate > age
                        false
                else
                        true
                end
        else
                if self.maximum_age_appropriate >= age and self.minimum_age_appropriate <= age
                        true
                else
                        false
                end
        end
  end

  def self.filter_by(filter)
    if filter == nil
        Product.all
    else
        min_age = filter[:min_age]
        max_price = filter[:max_price]
        if min_age != "" && max_price != ""
            Product.where("(minimum_age_appropriate <= ? OR minimum_age_appropriate IS NULL) AND price <= ?", min_age, max_price)
        elsif min_age != ""
            Product.where("minimum_age_appropriate <= ? OR minimum_age_appropriate IS NULL", min_age)
        elsif max_price != ""
            Product.where("price <= ?", max_price)
        else
            Product.all
        end
    end
  end

  def self.sorted_by(field)
       if Product.column_names.include?(field)
                Product.order(field)
        else
                Product.order("name")
        end
  end
end
