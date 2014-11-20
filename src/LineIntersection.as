package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[SWF(width="600", height="400", framRate="30", backgroundColor="#eeeeee")]
	
	public class LineIntersection extends Sprite
	{
		private var oldPoint:Point;
		private var point1:Point = new Point(400,100);
		private var point2:Point = new Point(160,300);
		
		private var sprite1:Sprite = new Sprite();
		private var sprite2:Sprite = new Sprite();
		private var sprite3:Sprite = new Sprite();
		private var sprite4:Sprite = new Sprite();
		private var sprite5:Sprite = new Sprite();
		private var sprite6:Sprite = new Sprite();
		private var sprite7:Sprite = new Sprite();
		
		private var isMove1:Boolean = false;
		private var isMove2:Boolean = false;
		
		public function LineIntersection()
		{
			addChild(sprite1);
			addChild(sprite2);
			addChild(sprite4);
			addChild(sprite5);
			addChild(sprite6);
			addChild(sprite7);
			addChild(sprite3);
			
			drawLine(point1.x, point1.y, point2.x, point2.y, sprite1);
			drawCircle(point1, sprite4, 0x66CC99);
			drawCircle(point2, sprite5, 0x66CC99);
			drawCircle(getMidPoint(point1, point2), sprite6, 0xcccccc, 5);
			drawRec(point1, point2, sprite7);
			
			drawLine(100, 50, 500, 280, sprite2, 0xcc0000);
			drawCircle(intersect(point1,point2,new Point(100, 50),new Point(500, 280)), sprite3);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandlers);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandlers);
			addEventListener(Event.ENTER_FRAME, loop);

		}
		private function loop(e:Event):void{
			if(oldPoint){
				
				var newPoint:Point = new Point(this.mouseX, this.mouseY);
				var d1:Number = Math.sqrt(Math.pow(newPoint.x - point1.x,2) + Math.pow(newPoint.y - point1.y,2));
				var d2:Number = Math.sqrt(Math.pow(newPoint.x - point2.x,2) + Math.pow(newPoint.y - point2.y,2));
				
				sprite3.graphics.clear();
				sprite2.graphics.clear();
				
				if(d1 < 40){
					point1 = newPoint;
					drawLine(point1.x, point1.y, point2.x, point2.y, sprite1);
					drawCircle(newPoint, sprite4, 0x66CC99);
					drawCircle(getMidPoint(point1, point2), sprite6, 0xcccccc, 5);
					drawRec(point1, point2, sprite7);
					return;
				}
				
				if(d2 < 40){
					point2 = newPoint;
					drawLine(point1.x, point1.y, point2.x, point2.y, sprite1);
					drawCircle(newPoint, sprite5, 0x66CC99);
					drawCircle(getMidPoint(point1, point2), sprite6, 0xcccccc, 5);
					drawRec(point1, point2, sprite7);
					return;
				}
				
				drawLine(oldPoint.x, oldPoint.y, newPoint.x, newPoint.y, sprite2, 0xcc0000);
				drawCircle(intersect(point1,point2,oldPoint,newPoint), sprite3);
				
			}
		}
		
		private function intersect(a1:Point, a2:Point, c1:Point, c2:Point ):Point{
			
			// y1 = mx1 + b1, y2 = mx2 + b2
			// m = change in y / change in x
			
			var m1:Number = (a2.y - a1.y) / (a2.x - a1.x);
			var m2:Number = (c2.y - c1.y) / (c2.x - c1.x);
			
			var b1:Number = a1.y - (m1 * a1.x);
			var b2:Number = c1.y - m2 * c1.x;
			
			// y - y = m1*x + b1  - m2*x - b2
			// m1x + b1 = m2x - b2
			// m2x + m1x + b1 = b2
			// x = b2 - b1 / m2 - m1
			var xpoint:Number = Math.sqrt(Math.pow((b1 - b2) / (m1 - m2),2));
			var ypoint:Number = m1 * xpoint + b1;
			
			var pointPoint:Point = new Point(xpoint, ypoint);
			
			//var rec:Rectangle = new Rectangle(a1.x, a1.y,
			
			var mX:Number = Math.min(a1.x, a2.x);
			var maxX:Number = Math.max(a1.x, a2.x);
			
			if(pointPoint.x < mX || pointPoint.x > maxX) {
				return null;
			}
			
			return pointPoint;
			
			// check in any point on any vector..
			//trace("check formula on any points y= ", m1 * a1.x + b1);
		}
		
		private function getMidPoint(p1:Point, p2:Point):Point{
			var midX:Number = (p1.x + p2.x) /2;
			var midY:Number = (p1.y + p2.y) /2;
			
			return new Point(midX, midY);
		}
		
		private function getDisplacement(p1:Point, p2:Point):Number{
			return Math.sqrt(Math.pow(p1.x - p2.x,2) + Math.pow(p1.y - p2.y,2));
		}
		
		
		private function drawLine(x1:Number, y1:Number, x2:Number, y2:Number, sprite:Sprite, color:uint = 0x000000):void{
			
			sprite.graphics.clear();
			sprite.graphics.lineStyle(2, color);
			sprite.graphics.moveTo(x1,y1);
			sprite.graphics.lineTo(x2,y2);
			
		}
		
		private function drawCircle(p:Point, sprite:Sprite, color:uint = 0x00CCFF, radius:Number = 7):void{
			
			if(!p) return;
			
			sprite.graphics.clear();
			sprite.graphics.beginFill(color, .9);
			sprite.graphics.drawCircle(p.x, p.y, radius);
			sprite.graphics.endFill();
		}
		
		private function drawRec(p1:Point,p2:Point, sprite:Sprite, _color:uint = 0xcccccc,_alpha:Number = 0.3 ):void{
			
			var mX:Number = Math.min(p1.x, p2.x);
			var mY:Number = Math.min(p1.y, p2.y);
			
			sprite.graphics.clear();
			sprite.graphics.lineStyle(2, _color,_alpha);
			sprite.graphics.drawRect(mX, mY, Math.abs(p1.x - p2.x), Math.abs(p1.y - p2.y));
		}
		
		private function mouseHandlers(e:MouseEvent):void{
			if(e.type == MouseEvent.MOUSE_DOWN){
				oldPoint = new Point(this.mouseX, this.mouseY);
			}else if(e.type == MouseEvent.MOUSE_UP){
				oldPoint = null;
			}
		}
	}
}