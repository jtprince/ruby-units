require File.join(File.dirname(__FILE__), '../spec_helper')
require 'ruby-units'

describe Unit, '.from_signature()' do
  
  it 'should return a Unit when receiving integer signature args' do
    Unit.from_signature(0).is_a?(Unit).should == true
  end
  
  it 'should raise TypeError when receiving non-integer signature args' do
    running {Unit.from_signature('')}.should             raise_error(TypeError)
    running {Unit.from_signature([])}.should             raise_error(TypeError)
    running {Unit.from_signature(:bad => 'args')}.should raise_error(TypeError)
  end
  
  # Type checking on the scalar arg is the job of Unit.initialize, not Unit.from_signature
  
  it 'should raise TypeError when receiving non-integer vector_base args' do
    running {Unit.from_signature(0, 1, '')}.should             raise_error(TypeError)
    running {Unit.from_signature(0, 1, [])}.should             raise_error(TypeError)
    running {Unit.from_signature(0, 1, :bad => 'args')}.should raise_error(TypeError)
  end
  
  it 'should default to scalar == 1' do
    Unit.from_signature(20, 1, 20).scalar.should == 1
  end
  
  it 'should return a scalar Unit when signature is 0' do
    # Somewhat brittle; depends on behavior of the rest of Unit; should add a scalar? method to Unit, to abstract out this issue
    Unit.from_signature(0).should == 1
  end
  
  it 'should pass through any given scalar arg' do
    Unit.from_signature(0, 12345).scalar.should == 12345
  end
  
  it 'should recover a base unit from its integer signature' do
    @base_unit = '10 N'.to_unit.to_base
    Unit.from_signature(@base_unit.signature, @base_unit.scalar).should == @base_unit
  end
  
  it 'should recover seconds units (for example) from its integer signature' do
    Unit.from_signature(20, 1, 20).unit_name.should  == 's'
  end
  
  it 'should recover perseconds units from its integer signature' do
    Unit.from_signature(-20, 1, 20).unit_name.should == '1/s'
  end
  
  it 'should raise ArgumentError if signature is ambiguous' do
    @vector_base = 20
    running {Unit.from_signature(@vector_base / 2, 1, @vector_base)}.should raise_error(ArgumentError)
  end
  
end


describe Unit, '#to_lowest()' do
  
  before :each do
    @unit = '0.00001 m'.to_unit
  end
  
  it 'should lower @unit if possible' do
    @unit.to_lowest('cm').unit_name.should == 'cm'
  end
  
  it 'should keep original unit if lowering is not possible' do
    @unit.to_lowest('km').should == @unit
  end
  
  it 'should not complain on incompatible units' do
    running {@unit.to_lowest('kg')}.should_not raise_error
  end
  
  it 'should not use incompatible units' do
    @unit.to_lowest('kg').should == @unit
  end
  
  it 'should not complain on no args' do
    running {@unit.to_lowest}.should_not raise_error
  end
  
  it 'should bias towards preferring positive orders of magnitude by default' do
    @unit.to_lowest('mm', 'um', 'mm').unit_name.should == 'um'
  end
  
  it 'should be possible to reverse bias' do
    @unit.to_lowest('um', 'mm', 'um', :bias => -2).unit_name.should == 'mm'
  end
  
end
