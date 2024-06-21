package utils.stuv {

	import flash.display.LoaderInfo;
	import flash.external.ExternalInterface;
	import flash.system.Capabilities;

	public class Platform {

		public static var browserUserAgent:String = "";

		public static const BROWSER_OTHER:String = "BROWSER_OTHER";
		public static const BROWSER_MSIE:String = "MSIE";
		public static const BROWSER_FIREFOX:String = "Firefox";
		public static const BROWSER_CHROME:String = "Chrome";
		public static const BROWSER_SAFARI:String = "Safari";

		protected static var url:String;

		public static function Init($loaderInfo:LoaderInfo):void {
			url = $loaderInfo.url;			
		}

		public static function get FlashPlayerVersion():String {
			return Capabilities.version;
		}

		public static function get FileName():String {
			var pos:int = url.lastIndexOf("/");
			return url.substr(pos+1);
		}

		public static function get UrlPath():String {
			return NavigatePath.current(url);
		}

		public static function get BrowserName():String {
			if 		(browserUserAgent.indexOf("MSIE") != -1) 	return BROWSER_MSIE;
			else if (browserUserAgent.indexOf("Firefox") != -1) return BROWSER_FIREFOX;
			else if (browserUserAgent.indexOf("Chrome") != -1)	return BROWSER_CHROME;
			else if (browserUserAgent.indexOf("Safari") != -1) 	return BROWSER_SAFARI;
			return BROWSER_OTHER;
		}
		
		public static function get HostingPageUrl():String {
			var url:String = "";
			if (ExternalInterface.available) {
				try {
					url = ExternalInterface.call("function(){return this.document.location.href}");
				} catch ($e:Error) {
					trace("Unable to access hosting page url. Error "+$e.errorID+": "+$e.name+": "+$e.message);
				}
			}
			return url;
		}
	}
}


