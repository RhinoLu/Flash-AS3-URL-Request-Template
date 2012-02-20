package
{
	import org.osflash.signals.Signal;
	
	public interface IClip 
	{
		function get signal():Signal;
		function set signal():void;
		function destory():void;
	}
	
}