package gtap.tracking
{
	import com.gaiaframework.api.Gaia;
	import com.gaiaframework.api.IAsset;
	import com.google.analytics.GATracker;
	import com.inruntime.utils.Global;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	/**
	 * 若頁面有嵌入 ga.ja 則推薦使用 GATracking_wwwins.swc
	 */
	public class GA extends Sprite
	{
		/**
		 * @public
		 *
		 */
		public static var MODE_AS3:String = "AS3";
		public static var MODE_BRIDGE:String = "Bridge";
		
		/**
		 * @protected
		 *
		 */
		protected static var _instance:GA;
		protected static var _canInit:Boolean = false;
		
		/**
		 * @private
		 *
		 */
		private var _tracker:GATracker;
		
		/**
		 * Creates an instance of GA.
		 *
		 */
		public function GA()
		{
			if (_canInit == false) {
				throw new Error(
					"GA is an singleton and cannot be instantiated."
				);
			}
		}
		
		/**
		 * Initial
		 * @param	id Tracking ID
		 */
		public static function init(display:DisplayObject, UA:String, mode:String, debug:Boolean = false):void
		{
			if (getInstance()._tracker) {
				throw new Error(
					"GA is already init!"
				);
			}else {
				getInstance()._tracker = new GATracker( display, UA, mode, debug );
			}
		}
		
		/**
		 * Track By ID
		 * @param	id Tracking ID
		 */
		/*public static function trackByID(id:String):void
		{
			//trace("trackByID : " + id);
			//trace(getInstance().trackByID);
			getInstance().trackByID(id);
		}*/
		
		/**
		 * Track Page
		 * @param	page page item
		 */
		public static function trackPage(page:String):void
		{
			getInstance().trackPage(page);
		}
		
		/**
		 * Track Event
		 * @param	category
		 * @param	action
		 * @param	label
		 */
		public static function trackEvent(category:String, action:String, label:String = null):void
		{
			getInstance().trackEvent(category, action, label);
		}
		
		/**
		 * @private
		 *
		 */
		/*private function trackByID(id:String):void
		{
			if (Gaia.api) {
				//trace(Gaia.api.getPage("index"));
				var _asset:IAsset = Gaia.api.getPage("index").assets.tracking; //trace(_asset);
				var _xml:XML = XML(_asset["xml"]);//trace(_xml);
				//trace(_xml.tracking.(@id == id).toXMLString());
				var _result:XMLList = _xml.tracking.(@id == id);//trace(_result);
				if (_result) {
					trace("type : " + _result.@type, ", section : " + _result.@section, ", tagID : " + _result.@tagID);
					setSection(_result.@section.toXMLString());
					if (_result.@type.toXMLString() == "pageName") {
						pageTagging();
					}else if (_result.@type.toXMLString() == "c42") {
						linkTagging(_result.@tagID);
					}
				}else {
					trace("trackID " + id + " no match !");
				}
			}else {
				trace("need under Gaiaframework !");
			}
		}*/
		
		private function trackPage(page:String):void
		{
			if (_tracker) {
				trace("trackPage : " + page);
				_tracker.trackPageview(page);
			}else {
				throw new Error(
					GA + " init first !"
				);
			}
		}
		
		private function trackEvent(category:String, action:String, label:String = null):void
		{
			if (_tracker) {
				trace("trackEvent : " + category + "," + action + "," + label);
				_tracker.trackEvent(category, action, label);
			}else {
				throw new Error(
					GA + " init first !"
				);
			}
		}
		
		
		/**
		 * @private
		 *
		 */
		protected static function getInstance():GA
		{
		  if (_instance == null) {
			_canInit = true;
			_instance = new GA();
			_canInit = false;
		  }
		  return _instance;
		}
	}
}