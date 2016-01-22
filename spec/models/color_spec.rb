require 'rails_helper'

describe Color, type: :model do
  context 'Association' do
    it {is_expected.to have_many(:imprintable_variants)}
  end
  
  context 'Validations' do
    it {is_expected.to validate_presence_of(:name)}
  end

  describe "::find_or_create_by_admin_color_name(admin_color.color)" do
    
    let(:admin_color) { create(:admin_inventory_color) }
    let!(:color) { create(:color) }
    context 'given an admin_color with out matching information in crm colors' do
      it 'should return a new color with name admin_color information' do
        
        not_found = Color::find_by(name: admin_color.color)
        color =  Color::find_or_create_by_admin_color_name(admin_color.color)

        expect(not_found).to be_nil
        expect(color.name).to eq(admin_color.color)
      end
    end

    context 'given an admin_color with matching information in crm colors' do
      
      before { allow(admin_color).to receive(:color) {color.name} }

      it 'should return the color found in crm' do
        found = Color::find_by(name: admin_color.color)
        color = Color::find_or_create_by_admin_color_name(admin_color.color)
      
        expect(found.name).to eq(admin_color.color)
        expect(color.name).to eq(admin_color.color)
      end
    end
  end
end
