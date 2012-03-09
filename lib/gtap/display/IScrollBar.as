package gtap.display 
{
	import flash.events.Event;
	
	public interface IScrollBar 
	{
		function init(e:Event = null):void
		function chkHeight():void
		function get scrollProgress():Number
		function addScrollListener():void
		function removeScrollListener():void
	}
}