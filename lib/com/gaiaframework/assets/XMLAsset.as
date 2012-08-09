/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2009
* Author: Steven Sacks
*
* blog: http://www.stevensacks.net/
* forum: http://www.gaiaflashframework.com/forum/
* wiki: http://www.gaiaflashframework.com/wiki/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is released under the MIT License:
* http://www.opensource.org/licenses/mit-license.php 
*****************************************************************************************************/

package com.gaiaframework.assets
{
	import com.gaiaframework.api.IXml;

	public class XMLAsset extends TextAsset implements IXml
	{		
		function XMLAsset()
		{
			super();
		}
		public function get xml():XML
		{
			return XML(_data);
		}
		override public function toString():String
		{
			return "[XMLAsset] " + _id + " : " + _order + " ";
		}
	}
}