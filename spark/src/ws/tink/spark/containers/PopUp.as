package ws.tink.spark.containers
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	import mx.managers.PopUpManager;
	import mx.styles.ISimpleStyleClient;
	
	import spark.components.Application;
	
	[DefaultProperty("popUp")]
	
	public class PopUp extends UIComponent
	{
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function PopUp()
		{
			super();
			
			addEventListener( Event.ADDED_TO_STAGE, addedToStage, false, 0, true );
			addEventListener( Event.REMOVED_FROM_STAGE, removedFromStage, false, 0, true );
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  displayPopUp
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the displayPopUp property.
		 */
		private var _displayPopUp:Boolean;
		
		/**
		 *  If <code>true</code>, adds the <code>popUp</code> control to the PopUpManager. 
		 *  If <code>false</code>, it removes the control.  
		 *  
		 *  @default false
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get displayPopUp():Boolean
		{
			return _displayPopUp;
		}
		
		/**
		 *  @private
		 */
		public function set displayPopUp( value:Boolean ):void
		{
			if( value == _displayPopUp ) return;     
			
			_displayPopUp = value; 
			addOrRemovePopUp();
		}
		
		//----------------------------------
		//  modal
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the modal property.
		 */
		private var _modal:Boolean;
		
		/**
		 *  
		 *
		 *  @default false
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get modal():Boolean
		{
			return _modal;
		}
		
		/**
		 *  @private
		 */
		public function set modal( value:Boolean ):void
		{
			if( value == _modal ) return;     
			
			_modal = value; 
		}
		
		
		
		//----------------------------------
		//  popUp
		//----------------------------------
		
		private var _popUp:IFlexDisplayObject;
		
		[Bindable ("popUpChanged")]
		
		/**
		 *  The IFlexDisplayObject to add to the PopUpManager when the PopUpAnchor is opened. 
		 *  If the <code>popUp</code> control implements IFocusManagerContainer, the 
		 *  <code>popUp</code> control will have its
		 *  own FocusManager. If the user uses the Tab key to navigate between
		 *  controls, only the controls in the <code>popUp</code> control are accessed. 
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */ 
		public function get popUp():IFlexDisplayObject 
		{ 
			return _popUp 
		}
		
		/**
		 *  @private
		 */
		public function set popUp(value:IFlexDisplayObject):void
		{
			if ( _popUp == value )
				return;
			
			_popUp = value;
			
			if ( _popUp is ISimpleStyleClient )
				ISimpleStyleClient( _popUp ).styleName = this;
			
			dispatchEvent( new Event( "popUpChanged" ) );
		}
		
		
		//----------------------------------
		//  fullScreen
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the fullScreen property.
		 */
		private var _fullScreen:Boolean;
		
		/**
		 *  
		 *
		 *  @default
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get fullScreen():Boolean
		{
			return _fullScreen;
		}
		
		/**
		 *  @private
		 */
		public function set fullScreen( value:Boolean ):void
		{
			if( value == _fullScreen ) return;     
			
			_fullScreen = value; 
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private 
		 */
		private function addOrRemovePopUp():void
		{
			if ( stage == null )
				return;
			
			if ( popUp == null )
				return;
			
			if ( DisplayObject(popUp).parent == null && displayPopUp )
			{
				PopUpManager.addPopUp( popUp, this, modal );
				
				if( fullScreen )
					systemManager.addEventListener( ResizeEvent.RESIZE, systemManager_resize, false, 0, true );
				
				if ( popUp is IUIComponent )
					IUIComponent(popUp).owner = this;
//				popUpIsDisplayed = true;
				
//				if (popUp is UIComponent && !popUpSizeCaptured)
//				{
//					popUpWidth = UIComponent( popUp ).explicitWidth;
//					popUpHeight = UIComponent( popUp ).explicitHeight;
//					UIComponent(popUp).validateNow();
//					popUpSizeCaptured = true;
//				}   
//				
//				applyPopUpTransform(width, height);
				
				if( fullScreen )
				{
					popUp.width = systemManager.screen.width;
					popUp.height = systemManager.screen.height;
				}
			}
			else if ( DisplayObject(popUp).parent != null && displayPopUp == false )
			{
				removeAndResetPopUp();
			}
		}
		
		/**
		 *  @private
		 */
		private function removeAndResetPopUp():void
		{
			PopUpManager.removePopUp(popUp);
			systemManager.removeEventListener( ResizeEvent.RESIZE, systemManager_resize, false );
//			popUpIsDisplayed = false;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------	
		
		/**
		 *  @private
		 */	
		protected function addedToStage( event:Event ):void
		{
			addOrRemovePopUp(); 
		}
		
		/**
		 *  @private
		 */	
		protected function removedFromStage( event:Event ):void
		{
			if (popUp != null && DisplayObject(popUp).parent != null)
				removeAndResetPopUp();
		}
		
		/**
		 *  @private
		 */	
		protected function systemManager_resize( event:ResizeEvent ):void
		{
			if( fullScreen )
			{
				popUp.width = systemManager.screen.width;
				popUp.height = systemManager.screen.height;
			}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden event handlers
		//
		//--------------------------------------------------------------------------
		
		
	}
}