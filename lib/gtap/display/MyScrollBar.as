package gtap.display
{
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	public class MyScrollBar extends Sprite implements IScrollBar
	{
		private var cont_mc:DisplayObject;
		private var mask_mc:DisplayObject;
		public var scroll_bar:MovieClip;
		public var scroll_up:MovieClip;
		public var scroll_down:MovieClip;
		public var scroll_bg:MovieClip;
		public var wheel_factor:Number = 5;
		//scroll 高低點位置
		private var topY:Number;
		private var downY:Number;
		//cont 高低點位置
		private var cont_downY:Number;
		public var cont_topY:Number;
		
		private var _scrollProgress:Number;
		
		public function MyScrollBar(_cont:DisplayObject, _mask:DisplayObject):void
		{
			cont_mc = _cont;
			mask_mc = _mask;
			
			if (stage) {
				init();
			}else {
				addEventListener(Event.ADDED_TO_STAGE , init);
			}
		}
		
		public function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE , init);
			addEventListener(Event.REMOVED_FROM_STAGE , onRemoveFromStage);
			
			//topY = mask_mc.y + scroll_up.height;
			topY = scroll_up.y;
			//downY = mask_mc.y + mask_mc.height - scroll_bar.height - scroll_down.height;
			downY = scroll_down.y - scroll_bar.height;
			cont_downY = mask_mc.y;
			//cont_topY = 0;
			
			chkHeight();
		}

		private function scrollOVER(e:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(e.target);
			mc.gotoAndStop(2);
		}

		private function scrollOUT(e:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(e.target);
			mc.gotoAndStop(1);
		}

		private function scrollCLICK(e:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(e.target);
			var toY:Number;
			if(mc.name == "scroll_up"){
				toY = scroll_bar.y - 10;
				if(toY < topY){
					toY = topY;
				}
				scroll_bar.y = toY;
			}else if(mc.name == "scroll_down"){
				toY = scroll_bar.y + 10;
				if(toY > downY){
					toY = downY;
				}
				scroll_bar.y = toY;
			}
		}

		private function scrollDOWN(e:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(e.target);
			mc.startDrag(false,new Rectangle(mc.x , topY , 0 , downY-topY));
		}
		
		private function scrollUP(e:MouseEvent):void
		{
			//var mc:MovieClip=MovieClip(e.target);
			scroll_bar.stopDrag();
		}
		
		private function mouseWheelHandler(event:MouseEvent):void
		{
			var toY = scroll_bar.y - event.delta * wheel_factor;
			if(toY < topY){
				scroll_bar.y = topY;
			}else if(toY > downY){
				scroll_bar.y = downY;
			}else{
				scroll_bar.y = toY;
			}
		}
		
		protected function rolling(e:Event):void
		{
			var toY:Number = cont_downY + (scroll_bar.y - topY) * (cont_topY - cont_downY) / (downY - topY);
			cont_mc.y += (toY - cont_mc.y) * 0.1;
		}
		
		public function chkHeight():void
		{
			//scroll_bar.y = topY;
			scroll_bar.y = scroll_up.y;
			if (cont_mc.height < mask_mc.height) {
				removeScrollListener();
				cont_mc.y = cont_downY;
				scroll_bar.visible = false;
				scroll_up.visible = false;
				scroll_down.visible = false;
				scroll_bg.visible = false;
			}else {
				addScrollListener();
				
				scroll_bar.visible = true;
				scroll_bar.buttonMode = true;
				scroll_bar.mouseChildren = false;
				
				scroll_bg.visible = true;
					
				scroll_up.visible = true;
				scroll_up.buttonMode = true;
				scroll_up.mouseChildren = false;
				
				scroll_down.visible = true;
				scroll_down.buttonMode = true;
				scroll_down.mouseChildren = false;
				
				//trace(cont_mc);
				//if (!cont_topY) {
					cont_topY = cont_downY - (cont_mc.height - mask_mc.height) -10;
				//}
			}
		}
		
		public function addScrollListener():void
		{
			scroll_bar.addEventListener(MouseEvent.ROLL_OVER , scrollOVER);
			scroll_bar.addEventListener(MouseEvent.ROLL_OUT , scrollOUT);
			scroll_bar.addEventListener(MouseEvent.MOUSE_DOWN , scrollDOWN);
			scroll_bar.addEventListener(MouseEvent.MOUSE_UP , scrollUP);
			
			scroll_up.addEventListener(MouseEvent.ROLL_OVER , scrollOVER);
			scroll_up.addEventListener(MouseEvent.ROLL_OUT , scrollOUT);
			scroll_up.addEventListener(MouseEvent.CLICK , scrollCLICK);
			
			scroll_down.addEventListener(MouseEvent.ROLL_OVER , scrollOVER);
			scroll_down.addEventListener(MouseEvent.ROLL_OUT , scrollOUT);
			scroll_down.addEventListener(MouseEvent.CLICK , scrollCLICK);
			
			stage.addEventListener(MouseEvent.MOUSE_UP , scrollUP);
			stage.addEventListener(Event.ENTER_FRAME , rolling);
			
			cont_mc.addEventListener(MouseEvent.MOUSE_WHEEL , mouseWheelHandler);
		}
		
		public function removeScrollListener():void
		{
			scroll_up.removeEventListener(MouseEvent.ROLL_OVER , scrollOVER);
			scroll_up.removeEventListener(MouseEvent.ROLL_OUT , scrollOUT);
			scroll_up.removeEventListener(MouseEvent.CLICK , scrollCLICK);
			
			scroll_down.removeEventListener(MouseEvent.ROLL_OVER , scrollOVER);
			scroll_down.removeEventListener(MouseEvent.ROLL_OUT , scrollOUT);
			scroll_down.removeEventListener(MouseEvent.CLICK , scrollCLICK);
			
			scroll_bar.removeEventListener(MouseEvent.ROLL_OVER , scrollOVER);
			scroll_bar.removeEventListener(MouseEvent.ROLL_OUT , scrollOUT);
			scroll_bar.removeEventListener(MouseEvent.MOUSE_DOWN , scrollDOWN);
			scroll_bar.removeEventListener(MouseEvent.MOUSE_UP , scrollUP);
			
			stage.removeEventListener(MouseEvent.MOUSE_UP , scrollUP);
			stage.removeEventListener(Event.ENTER_FRAME , rolling);
			
			cont_mc.removeEventListener(MouseEvent.MOUSE_WHEEL , mouseWheelHandler);
		}
		
		//**********************************************************************************************************************
		
		protected function onRemoveFromStage(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE , onRemoveFromStage);
			
			removeScrollListener();
		}
		
		public function get scrollProgress():Number 
		{
			_scrollProgress = (scroll_bar.y - topY) / (downY - topY);
			return _scrollProgress;
		}
	}
}