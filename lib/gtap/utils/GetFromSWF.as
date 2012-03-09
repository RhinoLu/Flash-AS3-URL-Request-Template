package gtap.utils 
{
	/**
	 * ...
	 * @author Rhino Lu
	 */
	
	public function GetFromSWF(name:String, tmploader:Loader):Class
	{
		var classReference:Class = tmploader.contentLoaderInfo.applicationDomain.getDefinition(name) as Class;
		return new classReference;
	}
}