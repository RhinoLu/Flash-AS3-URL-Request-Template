package gtap.utils 
{
	
	public class ChkRepeatedValue 
	{
		/**
		 * 檢查陣列中的值是否有重複值，只能是一維陣列，例[0,1,2,3,4,5,6]，常用於表單檢查
		 * 例[0,1,1,3,3]將回傳[[1, 2], [3, 4]]
		 * @param	_array 待檢查之陣列
		 * @return 陣列，例如 [[0, 1], [2, 3, 4]] 代表 第0,1個相同，第2,3,4個值相同
		 */
		public static function findRepeatedValue(_array:Array):Array
		{
			if (_array.length < 2) return null;
			var newArray:Array = createObjectArray(_array);
			var resultArray:Array = [];
			var tmpArray:Array;
			for (var i:int = 0; i < newArray.length; i++) 
			{
				if (newArray[i] != null) {
					tmpArray = [newArray[i].id];
					for (var j:int = i + 1; j < newArray.length; j++) 
					{
						if (newArray[j] != null) {
							if (newArray[i].value == newArray[j].value) {
								tmpArray.push(newArray[j].id);
								newArray[j] = null;
							}
						}
					}
					if (tmpArray.length > 1) {
						resultArray.push(tmpArray);
					}
				}
			}
			//t.obj(resultArray);
			return resultArray;
		}
		
		/**
		 * 產生「序號-值」的陣列
		 * @param	_array
		 * @return
		 */
		private static function createObjectArray(_array:Array):Array
		{
			var newArray:Array = [];
			var _obj:Object;
			for (var i:int = 0; i < _array.length; i++) 
			{
				_obj = { };
				_obj.id = i;
				_obj.value = _array[i];
				newArray[i] = _obj;
			}
			
			return newArray;
		}
		
		
		
		
		
	}

}