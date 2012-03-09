package gtap.utils
{
	import flash.display.IGraphicsData;
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	/**
	 * @link http://wonderfl.net/c/1OHO
	 */
	public class GraphicsPlus extends Shape{
		public function GraphicsPlus(){
			beginFill = this.graphics.beginFill;
			beginGradientFill = this.graphics.beginGradientFill;
			beginShaderFill = this.graphics.beginShaderFill;
			clear = this.graphics.clear;
			curveTo = this.graphics.curveTo;
			drawCircle = this.graphics.drawCircle;
			drawEllipse = this.graphics.drawEllipse;
			drawGraphicsData = this.graphics.drawGraphicsData;
			drawPath = this.graphics.drawPath;
			drawRect = this.graphics.drawRect;
			drawRoundRect = this.graphics.drawRoundRect;
			drawRoundRectComplex = this.graphics.drawRoundRectComplex;
			drawTriangles = this.graphics.drawTriangles;
			endFill = this.graphics.endFill;
			lineGradientStyle = this.graphics.lineGradientStyle;
			lineShaderStyle = this.graphics.lineShaderStyle;
			lineStyle = this.graphics.lineStyle;
			lineTo = this.graphics.lineTo;
			moveTo = this.graphics.moveTo;
		}
		
		// 扇形を描くメソッド
		// x:中心のx座標  y:中心のy座標
		// r1:外円の半径  r2:内円の半径
		// a1:始点の角度  a2:終点の角度
		public function drawFan(x:Number, y:Number, r1:Number, r2:Number, a1:Number, a2:Number):void{
			
			//角度をラジアンに直す
			var radian1:Number = a1*Math.PI/180;
			var radian2:Number = a2*Math.PI/180;
			
			// 外円の描画
			draw(x, y, r1, radian1, radian2, false);
			// 内円の描画
			draw(x, y, r2, radian2, radian1, true);
		}
		
		//扇形の外円・内円の描画
		//参考サイト丸写し…
		private function draw(x:Number, y:Number, r:Number, t1:Number, t2:Number, lineTo:Boolean):void{
			var div:Number = Math.max(1, Math.floor(Math.abs(t1 - t2) / 0.4));
			var lx:Number;
			var ly:Number;
			var lt:Number;

			for (var i:int = 0; i <= div; i++) {
				var ct:Number = t1 + (t2 - t1)*i/div;
				var cx:Number = Math.cos(ct)*r + x;
				var cy:Number = Math.sin(ct)*r + y;
				
				if(i==0){
					if(lineTo) this.graphics.lineTo(cx, cy);
					else this.graphics.moveTo(cx, cy);
				}else{
					var cp:Point = getControlPoint(new Point(lx, ly), lt+Math.PI/2, new Point(cx, cy), ct+Math.PI/2); 
					this.graphics.curveTo(cp.x, cp.y, cx, cy);
				}
				lx = cx;
				ly = cy;
				lt = ct;
			}
		}
		
		//コントロールポイントの計算
		//参考サイト丸写し…
		private function getControlPoint(p1:Point, t1:Number, p2:Point, t2:Number):Point{
			var dif:Point = p2.subtract(p1);
			var l12:Number = Math.sqrt(dif.x*dif.x + dif.y*dif.y);
			var t12:Number = Math.atan2(dif.y, dif.x);
			var l13:Number = l12*Math.sin(t2 - t12)/Math.sin(t2 - t1);
			
			return new Point(p1.x+l13*Math.cos(t1), p1.y+l13*Math.sin(t1));
		}
		
		
		//------------------------------------------------
		//「Graphicsクラスのサブクラス」風に見せるための変数
		public var beginFill:Function;
		public var beginGradientFill:Function;
		public var beginShaderFill:Function;
		public var clear:Function;
		public var curveTo:Function;
		public var drawCircle:Function;
		public var drawEllipse:Function;
		public var drawGraphicsData:Function;
		public var drawPath:Function;
		public var drawRect:Function;
		public var drawRoundRect:Function;
		public var drawRoundRectComplex:Function;
		public var drawTriangles:Function;
		public var endFill:Function;
		public var lineGradientStyle:Function;
		public var lineShaderStyle:Function;
		public var lineStyle:Function;
		public var lineTo:Function;
		public var moveTo:Function;
	}
}