class Product < ActiveRecord::Base
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

  def self.sorted_by(field)
       if Product.column_names.include?(field)
                Product.order(field)
        else
                Product.order("name")
        end
  end
end
