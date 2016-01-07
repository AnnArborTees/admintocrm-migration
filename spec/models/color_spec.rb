require 'rails_helper'

describe Color, type: :model do
  context 'Association' do
    it {is_expected.to have_many(:imprintable_variants)}
  end
  
  context 'Validations' do
    it {is_expected.to validate_presence_of(:name)}
  end

  describe "::find_by_admin_color(admin_color)" do
    let!(:admin_color) { create(:admin_inventory_color) }
    let!(:color) { create(:color) }
    context 'given an admin_color with color "Green"' do
      it 'should return a color with name "Green"' do
        new_color = Color::find_by_admin_color(admin_color)

        expect(new_color.class).to eq(Color)
        expect(new_color.name).to eq("Green")
      end
    end
  end
end
