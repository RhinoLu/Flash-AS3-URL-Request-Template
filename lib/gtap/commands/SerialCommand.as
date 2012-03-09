package gtap.commands 
{
	/**
	 * @author Allen Chou
	 * @link http://active.tutsplus.com/tutorials/actionscript/thinking-in-commands-part-1-of-2/
	 */
	import flash.events.Event;
	
	public class SerialCommand extends Command
	{
		private var _commands:Array;
		
		public function SerialCommand(delay:Number = 0, ...commands)
		{
			super(delay);
			_commands = commands;
		}
		
		private var _completeCommandCount:int;
		
		override final protected function execute():void
		{
			
			//set the complete command count to zero
			_completeCommandCount = 0;
			
			//listen for the complete event of the first subcommand...
			_commands[0].addEventListener(Event.COMPLETE, onSubcommandComplete);
			
			//...and start the subcommand
			_commands[0].start();
		}
		
		private function onSubcommandComplete(e:Event):void
		{
			//stop listening for the complete event
			Command(e.target).removeEventListener(Event.COMPLETE, onSubcommandComplete);
			
			//increment the complete command count
			_completeCommandCount++;
			
			//if all the commands are complete...
			if (_completeCommandCount == _commands.length) {
				
				//...then this serial command is complete
				complete();
			} else {
				
				//...otherwise listen for the complete event of the next subcommand...
				_commands[_completeCommandCount].addEventListener(Event.COMPLETE, onSubcommandComplete);
				
				//...and start the subcommand
				_commands[_completeCommandCount].start();
			}
		}
	}
}