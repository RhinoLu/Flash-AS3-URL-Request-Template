package gtap.utils 
{
	import flash.net.LocalConnection;
	import flash.system.Capabilities;
	
	public function Online():Boolean
	{
		return !((new LocalConnection().domain == "localhost") || Capabilities.playerType == "Desktop");
	}
}