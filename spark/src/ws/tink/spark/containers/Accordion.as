/*

Copyright (c) 2010 Tink Ltd - http://www.tink.ws

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/

package ws.tink.spark.containers
{
	import mx.utils.BitFlagUtil;
	
	import spark.components.supportClasses.ButtonBarBase;
	import spark.effects.easing.IEaser;
	
	import ws.tink.spark.layouts.AccordionLayout;
	import ws.tink.spark.layouts.supportClasses.INavigatorLayout;
	
	import mx.utils.BitFlagUtil;
	
	/**
	 *  An Spark Accordion navigator container has a collection IVisualElements,
	 *  but only one of them at a time is fully visible.
	 *  It creates and manages navigator buttons, which you use
	 *  to navigate between the elements.
	 *  There is one navigator button associated with each element,
	 *  and each navigator button belongs to the Accordion container, not to the child.
	 *  When the user clicks a navigator button, the associated element
	 *  is displayed.
	 *  The transition to the new child uses an animation to make it clear to
	 *  the user that one child is disappearing and a different one is appearing.
	 *
	 *  @mxml
	 *
	 *  <p>The <code>&lt;st:Accordion&gt;</code> tag inherits all of the
	 *  tag attributes of its superclass, and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;st:Accordion
	 *    <strong>Properties</strong>
	 *    buttonRotation="none|left|right"
	 *    direction="vertical|horizontal"
	 *    duration="700"
	 *    easer=""<i>IEaser</i>""
	 *    labelField="label"
	 *    labelFunction="null"
	 *    minElementSize="0"
	 *    useScrollRect"true"
	 *  
	 *    <strong>Styles</strong>
	 *    <strong>Events</strong>
	 *  /&gt;
	 *  </pre>
	 *
	 *  @includeExample examples/AccordionExample.mxml
	 *
	 *  @see ws.tink.spark.layouts.AccordionLayout
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class Accordion extends Navigator
	{
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		// Constants used for accordionLayout proxied properties.
		
		/**
		 *  @private
		 */
		private static const REQUIRE_SELECTION_PROPERTY_FLAG:uint = 1 << 0;
		
		/**
		 *  @private
		 */
		private static const BUTTON_ROTATION_PROPERTY_FLAG:uint = 1 << 1;
		
		/**
		 *  @private
		 */
		private static const DIRECTION_PROPERTY_FLAG:uint = 1 << 2;
		
		/**
		 *  @private
		 */
		private static const DURATION_PROPERTY_FLAG:uint = 1 << 3;
		
		/**
		 *  @private
		 */
		private static const EASER_PROPERTY_FLAG:uint = 1 << 4;
		
		/**
		 *  @private
		 */
		private static const MIN_ELEMENT_SIZE_PROPERTY_FLAG:uint = 1 << 5;
		
		/**
		 *  @private
		 */
		private static const USE_SCROLL_RECT_PROPERTY_FLAG:uint = 1 << 6;
		
		
		// Constants used for buttonBar proxied properties.
		
		/**
		 *  @private
		 */
		private static const LABEL_FIELD_PROPERTY_FLAG:uint = 1 << 0;
		
		/**
		 *  @private
		 */
		private static const LABEL_FUNCTION_PROPERTY_FLAG:uint = 1 << 1;
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function Accordion()
		{
			super();
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Skin Parts
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  buttonBar
		//---------------------------------- 
		
		[SkinPart(required="true")]
		
		/**
		 *  A required skin part that is used to navigate between elements.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var buttonBar:ButtonBarBase;
		
		
		//----------------------------------
		//  accordionLayout
		//---------------------------------- 
		
		[SkinPart(required="true")]
		
		/**
		 *  A required skin part that defines the layout for the Accordion.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public var accordionLayout:AccordionLayout;
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties proxied to accordionLayout
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Several properties are proxied to accordionLayout.  However, when accordionLayout
		 *  is not around, we need to store values set on Accordion.  This object 
		 *  stores those values.  If accordionLayout is around, the values are stored 
		 *  on the accordionLayout directly.  However, we need to know what values 
		 *  have been set by the developer on the Accordion (versus set on 
		 *  the accordionLayout or defaults of the accordionLayout) as those are values 
		 *  we want to carry around if the accordionLayout changes (via a new skin). 
		 *  In order to store this info effeciently, _accordionLayoutProperties becomes 
		 *  a uint to store a series of BitFlags.  These bits represent whether a 
		 *  property has been explicitely set on this Accordion.  When the 
		 *  accordionLayout is not around, _accordionLayoutProperties is a typeless 
		 *  object to store these proxied properties.  When accordionLayout is around,
		 *  _accordionLayoutProperties stores booleans as to whether these properties 
		 *  have been explicitely set or not.
		 */
		private var _accordionLayoutProperties:Object = {};
		
		
		//----------------------------------
		//  buttonRotation
		//----------------------------------    
		
		[Inspectable(category="General", enumeration="none,left,right", defaultValue="none")]
		
		/** 
		 *  @copy ws.tink.spark.layouts.AccordionLayout#buttonRotation
		 */
		public function get buttonRotation():String
		{
			return accordionLayout ? accordionLayout.buttonRotation : _accordionLayoutProperties.buttonRotation ;
		}
		/**
		 *  @private
		 */
		public function set buttonRotation( value:String ):void
		{
			if( value == buttonRotation ) return;
			
			if( accordionLayout )
			{
				accordionLayout.buttonRotation = value;
				_accordionLayoutProperties = BitFlagUtil.update( _accordionLayoutProperties as uint, BUTTON_ROTATION_PROPERTY_FLAG, true );
			}
			else
			{
				_accordionLayoutProperties.buttonRotation = value;
			}
		}
		
		
		//----------------------------------
		//  direction
		//----------------------------------    
		
		[Inspectable(category="General", enumeration="vertical,horizontal", defaultValue="vertical")]
		
		/** 
		 *  @copy ws.tink.spark.layouts.AccordionLayout#direction
		 */
		public function get direction():String
		{
			return accordionLayout ? accordionLayout.direction : _accordionLayoutProperties.direction;
		}
		/**
		 *  @private
		 */
		public function set direction( value:String ):void
		{
			if( value == direction ) return;
			
			if( accordionLayout )
			{
				accordionLayout.direction = value;
				_accordionLayoutProperties = BitFlagUtil.update( _accordionLayoutProperties as uint, DIRECTION_PROPERTY_FLAG, true );
			}
			else
			{
				_accordionLayoutProperties.direction = value;
			}
		}
		
		
		//----------------------------------
		//  duration
		//----------------------------------    
		
		/**
		 *  @copy ws.tink.spark.layouts.AccordionLayout#duration
		 */
		public function get duration():Number
		{
			return accordionLayout ? accordionLayout.duration : _accordionLayoutProperties.duration;
		}
		/**
		 *  @private
		 */
		public function set duration(value:Number):void
		{
			if( duration == value ) return;
			
			if( accordionLayout )
			{
				accordionLayout.duration = value;
				_accordionLayoutProperties = BitFlagUtil.update( _accordionLayoutProperties as uint, DURATION_PROPERTY_FLAG, true );
			}
			else
			{
				_accordionLayoutProperties.duration = value;
			}
		}
		
		
		
		//----------------------------------
		//  easer
		//----------------------------------    
		
		/**
		 *  @copy ws.tink.spark.layouts.AccordionLayout#easer
		 */
		public function get easer():IEaser
		{
			return accordionLayout ? accordionLayout.easer : _accordionLayoutProperties.easer;
		}
		/**
		 *  @private
		 */
		public function set easer(value:IEaser):void
		{
			if( easer == value ) return;
			
			if( accordionLayout )
			{
				accordionLayout.easer = value;
				_accordionLayoutProperties = BitFlagUtil.update( _accordionLayoutProperties as uint, EASER_PROPERTY_FLAG, true );
			}
			else
			{
				_accordionLayoutProperties.easer = value;
			}
		}
		
		
		//----------------------------------
		//  minElementSize
		//----------------------------------    
		
		/** 
		 *  @copy ws.tink.spark.layouts.AccordionLayout#minElementSize
		 */
		public function get minElementSize():Number
		{
			return accordionLayout ? accordionLayout.minElementSize : _accordionLayoutProperties.minElementSize;
		}
		/**
		 *  @private
		 */
		public function set minElementSize( value:Number ):void
		{
			if( minElementSize == value ) return;
			
			if( accordionLayout )
			{
				accordionLayout.minElementSize = value;
				_accordionLayoutProperties = BitFlagUtil.update( _accordionLayoutProperties as uint, MIN_ELEMENT_SIZE_PROPERTY_FLAG, true );
			}
			else
			{
				_accordionLayoutProperties.minElementSize = value;
			}
		}
		
		
		//----------------------------------
		//  requireSelection
		//---------------------------------- 
		
		/**
		 *  The storage property is in the NavigatorLayoutBase.
		 */
		
		[Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		
		/** 
		 *  @copy ws.tink.spark.layouts.AccordionLayout#requireSelection
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get requireSelection():Boolean
		{ 
			return accordionLayout ? accordionLayout.requireSelection : _accordionLayoutProperties.requireSelection;
		}
		/**
		 *  @private
		 */
		public function set requireSelection( value:Boolean ):void
		{
			if( value == buttonRotation ) return;
			
			if( accordionLayout )
			{
				accordionLayout.requireSelection = value;
				_accordionLayoutProperties = BitFlagUtil.update( _accordionLayoutProperties as uint, REQUIRE_SELECTION_PROPERTY_FLAG, true );
			}
			else
			{
				_accordionLayoutProperties.requireSelection = value;
			}
		}
		
		
		//----------------------------------
		//  useScrollRect
		//----------------------------------    
		
		/**
		 *  @copy ws.tink.spark.layouts.AccordionLayout#useScrollRect
		 */
		public function get useScrollRect():Boolean
		{
			return accordionLayout ? accordionLayout.useScrollRect : _accordionLayoutProperties.useScrollRect;
		}
		/**
		 *  @private
		 */
		public function set useScrollRect( value:Boolean ):void
		{
			if( useScrollRect == value ) return;
			
			if( accordionLayout )
			{
				accordionLayout.useScrollRect = value;
				_accordionLayoutProperties = BitFlagUtil.update( _accordionLayoutProperties as uint, USE_SCROLL_RECT_PROPERTY_FLAG, true );
			}
			else
			{
				_accordionLayoutProperties.useScrollRect = value;
			}
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties proxied to buttonBar
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Several properties are proxied to buttonBar.  However, when buttonBar
		 *  is not around, we need to store values set on Accordion.  This object 
		 *  stores those values.  If buttonBar is around, the values are stored 
		 *  on the buttonBar directly.  However, we need to know what values 
		 *  have been set by the developer on the Accordion (versus set on 
		 *  the buttonBar or defaults of the buttonBar) as those are values 
		 *  we want to carry around if the buttonBar changes (via a new skin). 
		 *  In order to store this info effeciently, _buttonBarProperties becomes 
		 *  a uint to store a series of BitFlags.  These bits represent whether a 
		 *  property has been explicitely set on this Accordion.  When the 
		 *  buttonBar is not around, _buttonBarProperties is a typeless 
		 *  object to store these proxied properties.  When buttonBar is around,
		 *  _buttonBarProperties stores booleans as to whether these properties 
		 *  have been explicitely set or not.
		 */
		private var _buttonBarProperties:Object = {};
		
		
		
		//----------------------------------
		//  labelField
		//----------------------------------
		
		/**
		 *  @copy spark.components.supportClasses.ListBase#labelField
		 */
		public function get labelField():String
		{
			return buttonBar ? buttonBar.labelField : _buttonBarProperties.labelField;
		}
		/**
		 *  @private
		 */
		public function set labelField( value:String ):void
		{
			if( labelField == value ) return 
				
			if( buttonBar )
			{
				buttonBar.labelField = value;
				_buttonBarProperties = BitFlagUtil.update( _buttonBarProperties as uint, LABEL_FIELD_PROPERTY_FLAG, true );
			}
			else
			{
				_buttonBarProperties.labelField = value;
			}
		}
		
		
		//----------------------------------
		//  labelFunction
		//----------------------------------
		
		/**
		 *  @copy spark.components.supportClasses.ListBase#labelFunction
		 */
		public function get labelFunction():Function
		{
			return buttonBar ? buttonBar.labelFunction : _buttonBarProperties.labelFunction;
		}
		
		/**
		 *  @private
		 */
		public function set labelFunction( value:Function ):void
		{
			if( labelFunction == value ) return; 
				
			if( buttonBar )
			{
				buttonBar.labelFunction = value;
				_buttonBarProperties = BitFlagUtil.update( _buttonBarProperties as uint, LABEL_FUNCTION_PROPERTY_FLAG, true );
			}
			else
			{
				_buttonBarProperties.labelFunction = value;
			}
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  layout
		//----------------------------------    
		
		/**
		 *  @private
		 */
		override public function set layout( value:INavigatorLayout ):void
		{
			throw( new Error( resourceManager.getString( "components", "layoutReadOnly" ) ) );
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			switch( instance )
			{
				case buttonBar :
				{
					// copy proxied values from _buttonBarProperties (if set) to buttonBar
					var newButtonBarProperties:uint = 0;
					
					if( _buttonBarProperties.labelField !== undefined )
					{
						buttonBar.labelField = _buttonBarProperties.labelField;
						newButtonBarProperties = BitFlagUtil.update( newButtonBarProperties as uint, LABEL_FIELD_PROPERTY_FLAG, true );
					}
					
					if( _buttonBarProperties.labelFunction !== undefined )
					{
						buttonBar.labelFunction = _buttonBarProperties.labelFunction;
						newButtonBarProperties = BitFlagUtil.update( newButtonBarProperties as uint, LABEL_FUNCTION_PROPERTY_FLAG, true );
					}
					
					_buttonBarProperties = newButtonBarProperties;
					
					buttonBar.dataProvider = this;
					if( accordionLayout ) accordionLayout.buttonBar = buttonBar;
					break;
				}
				case accordionLayout :
				{
					// copy proxied values from _accordionLayoutProperties (if set) to accordionLayout
					var newAccordionLayoutProperties:uint = 0;
					
					if( _accordionLayoutProperties.requireSelection !== undefined )
					{
						accordionLayout.requireSelection = _accordionLayoutProperties.requireSelection;
						newAccordionLayoutProperties = BitFlagUtil.update( newAccordionLayoutProperties as uint, BUTTON_ROTATION_PROPERTY_FLAG, true );
					}
					
					if( _accordionLayoutProperties.buttonRotation !== undefined )
					{
						accordionLayout.buttonRotation = _accordionLayoutProperties.buttonRotation;
						newAccordionLayoutProperties = BitFlagUtil.update( newAccordionLayoutProperties as uint, BUTTON_ROTATION_PROPERTY_FLAG, true );
					}
					
					if( _accordionLayoutProperties.direction !== undefined )
					{
						accordionLayout.direction = _accordionLayoutProperties.direction;
						newAccordionLayoutProperties = BitFlagUtil.update( newAccordionLayoutProperties as uint, DIRECTION_PROPERTY_FLAG, true );
					}
					
					if( _accordionLayoutProperties.duration !== undefined )
					{
						accordionLayout.duration = _accordionLayoutProperties.duration;
						newAccordionLayoutProperties = BitFlagUtil.update( newAccordionLayoutProperties as uint, DURATION_PROPERTY_FLAG, true );
					}
					
					if( _accordionLayoutProperties.easer !== undefined )
					{
						accordionLayout.easer = _accordionLayoutProperties.easer;
						newAccordionLayoutProperties = BitFlagUtil.update( newAccordionLayoutProperties as uint, EASER_PROPERTY_FLAG, true );
					}
					
					if( _accordionLayoutProperties.minElementSize !== undefined )
					{
						accordionLayout.minElementSize = _accordionLayoutProperties.minElementSize;
						newAccordionLayoutProperties = BitFlagUtil.update( newAccordionLayoutProperties as uint, MIN_ELEMENT_SIZE_PROPERTY_FLAG, true );
					}
					
					if( _accordionLayoutProperties.useScrollRect !== undefined )
					{
						accordionLayout.useScrollRect = _accordionLayoutProperties.useScrollRect;
						newAccordionLayoutProperties = BitFlagUtil.update( newAccordionLayoutProperties as uint, USE_SCROLL_RECT_PROPERTY_FLAG, true );
					}
					
					_accordionLayoutProperties = newAccordionLayoutProperties;
					
					if( buttonBar ) accordionLayout.buttonBar = buttonBar;
					break;
				}
			}
		}
		
		/**
		 *  @private
		 */
		override protected function partRemoved( partName:String, instance:Object ):void
		{
			super.partRemoved( partName, instance );
			
			switch( instance )
			{
				case buttonBar :
				{
					// copy proxied values from buttonBar (if explicitly set) to _buttonBarProperties
					var newButtonBarProperties:Object = {};
					
					if ( BitFlagUtil.isSet( _buttonBarProperties as uint, LABEL_FIELD_PROPERTY_FLAG ) )
						newButtonBarProperties.labelField = buttonBar.labelField;
					
					if ( BitFlagUtil.isSet( _buttonBarProperties as uint, LABEL_FUNCTION_PROPERTY_FLAG ) )
						newButtonBarProperties.labelFunction = buttonBar.labelFunction;
					
					_buttonBarProperties = newButtonBarProperties;
					
					if( accordionLayout ) accordionLayout.buttonBar = null;
					break;
				}
				case accordionLayout :
				{
					// copy proxied values from accordionLayout (if explicitly set) to _accordionLayoutProperties
					var newAccordionLayoutProperties:Object = {};
					
					if ( BitFlagUtil.isSet( _accordionLayoutProperties as uint, REQUIRE_SELECTION_PROPERTY_FLAG ) )
						newAccordionLayoutProperties.requireSelection = accordionLayout.requireSelection;
					
					if ( BitFlagUtil.isSet( _accordionLayoutProperties as uint, BUTTON_ROTATION_PROPERTY_FLAG ) )
						newAccordionLayoutProperties.buttonRotation = accordionLayout.buttonRotation;
					
					if ( BitFlagUtil.isSet( _accordionLayoutProperties as uint, DIRECTION_PROPERTY_FLAG ) )
						newAccordionLayoutProperties.direction = accordionLayout.direction;
					
					if ( BitFlagUtil.isSet( _accordionLayoutProperties as uint, DURATION_PROPERTY_FLAG ) )
						newAccordionLayoutProperties.duration = accordionLayout.duration;
					
					if ( BitFlagUtil.isSet( _accordionLayoutProperties as uint, EASER_PROPERTY_FLAG ) )
						newAccordionLayoutProperties.easer = accordionLayout.easer;
					
					if ( BitFlagUtil.isSet( _accordionLayoutProperties as uint, MIN_ELEMENT_SIZE_PROPERTY_FLAG ) )
						newAccordionLayoutProperties.minElementSize = accordionLayout.minElementSize;
					
					if ( BitFlagUtil.isSet( _accordionLayoutProperties as uint, USE_SCROLL_RECT_PROPERTY_FLAG ) )
						newAccordionLayoutProperties.useScrollRect = accordionLayout.useScrollRect;
					
					_accordionLayoutProperties = newAccordionLayoutProperties;
					break;
				}
			}
		}
	}
}