package sfs2x.games.cannoncombat.managers
{
	
	/*******************************************************************************************
	 * 
	 * TITLE: 		SFS2X Cannon Combat
	 * VERSION:		1.0
	 * RELEASE:		2012-03-14
	 * COPYRIGHT:	2012 gotoAndPlay() - http://www.smartfoxserver.com
	 * DEVELOPER:	A51 Integrated - http://a51integrated.com
	 * 
	 * This file is part of Cannon Combat.
	 * 
	 * Contributers: Wayne Helman, Fabricio Medeiros,
	 * 				 Steve Schoger, Andy Rohan
	 * 
	 * Cannon Combat is distributed in the hope that it will be useful,
	 * but WITHOUT ANY WARRANTY; without even the implied warranty of
	 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	 * included license for more details.
	 *
	 * You are not allowed to rent, lend, lease, license or distribute SFS2X Cannon Combat or a
	 * modified version of Cannon Combat to any other person or organization in any way.
	 * 
	 * For commercial licensing information, please contact gotoAndPlay().
	 * 
	 *******************************************************************************************/
	
	/**
	 * SoundManager
	 * 
	 * The SoundManager is a singleton that allows you to have various ways to control sounds in your project.
	 * The SoundManager can load external or library sounds, pause/mute/stop/control volume for one or more sounds at a time, 
	 * fade sounds up or down, and allows additional control to sounds not readily available through the default classes.
	 * This class is dependent on TweenLite (http://www.tweenlite.com) to aid in easily fading the volume of the sound.
	 * 
	 * @author Matt Przybylski [http://www.reintroducing.com]
	 * @version 1.0
	 * 
	 */

	import com.greensock.TweenLite;
	import com.greensock.plugins.*;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	TweenPlugin.activate([VolumePlugin]);
	
	public class SoundManager extends EventDispatcher
	{
		private var
			_globalVolume	:Number = 1.0,
			_soundsDict		:Dictionary,
			_sounds			:Array;
		
			
		
		/**
		 * Constructor
		 */
		public function SoundManager() 
		{
			_soundsDict = new Dictionary(true);
			_sounds = new Array();
		}
		
		
		
		/**
		 * Adds a sound from the library to the sounds dictionary for playing in the future.
		 * 
		 * @param $linkageID The class name of the library symbol that was exported for AS
		 * @param $name The string identifier of the sound to be used when calling other methods on the sound
		 * 
		 * @return Boolean A boolean value representing if the sound was added successfully
		 */
		public function addLibrarySound($linkageID:*, $name:String):Boolean
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				if (_sounds[i].name == $name) return false;
			}
			
			var sndObj	:Object = new Object(),
				snd		:Sound = new $linkageID;
			
			sndObj.name = $name;
			sndObj.sound = snd;
			sndObj.channel = new SoundChannel();
			
			sndObj.position = 0;
			sndObj.paused = true;
			sndObj.volume = 1;
			sndObj.startTime = 0;
			sndObj.loops = 0;
			sndObj.pausedByAll = false;
			
			_soundsDict[$name] = sndObj;
			_sounds.push(sndObj);
			
			return true;
		}
		
		
		
		/**
		 * Adds an external sound to the sounds dictionary for playing in the future.
		 * 
		 * @param $path A string representing the path where the sound is on the server
		 * @param $name The string identifier of the sound to be used when calling other methods on the sound
		 * @param $buffer The number, in milliseconds, to buffer the sound before you can play it (default: 1000)
		 * @param $checkPolicyFile A boolean that determines whether Flash Player should try to download a cross-domain policy file from the loaded sound's server before beginning to load the sound (default: false) 
		 * 
		 * @return Boolean A boolean value representing if the sound was added successfully
		 */
		public function addExternalSound($path:String, $name:String, $buffer:Number = 1000, $checkPolicyFile:Boolean = false):Boolean
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				if (_sounds[i].name == $name) return false;
			}
			
			var sndObj	:Object = new Object(),
				snd		:Sound = new Sound(new URLRequest($path), new SoundLoaderContext($buffer, $checkPolicyFile));
			
			sndObj.name = $name;
			sndObj.sound = snd;
			sndObj.channel = new SoundChannel();
			
			sndObj.position = 0;
			sndObj.paused = true;
			sndObj.volume = 1;
			sndObj.startTime = 0;
			sndObj.loops = 0;
			sndObj.pausedByAll = false;
			
			_soundsDict[$name] = sndObj;
			_sounds.push(sndObj);
			
			return true;
		}
		
		
		
		/**
		 * Adds an already downloaded sound to dictionary for playin immediately.
		 *
		 * @param $name The string identifier of the sound to be used when calling other methods on the sound
		 * @param $sound Sound object
		 * @return
		 */
		public function addLoadedSound($name:String, $sound:Sound):Boolean 
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				if (_sounds[i].name == $name) return false;
			}
			
			var sndObj:Object = new Object();
			sndObj.name = $name;
			sndObj.sound = $sound;
			sndObj.channel = new SoundChannel();
			
			var chan:SoundChannel = sndObj.channel;
			chan.addEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
			
			sndObj.position = 0;
			sndObj.paused = true;
			sndObj.volume = 1;
			sndObj.startTime = 0;
			sndObj.loops = 0;
			sndObj.pausedByAll = false;
			
			_soundsDict[$name] = sndObj;
			_sounds.push(sndObj);
			
			return true;
		}
		
		
		
		private function handleSoundComplete($e:Event):void 
		{
			dispatchEvent( new Event(Event.COMPLETE) );
			
			var s:SoundChannel = $e.currentTarget as SoundChannel;
			s.removeEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
		}
		
		
		
		/**
		 * Removes a sound from the sound dictionary.  After calling this, the sound will not be available until it is re-added.
		 * 
		 * @param $name The string identifier of the sound to remove
		 * 
		 * @return void
		 */
		public function removeSound($name:String):void
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				if (_sounds[i].name == $name)
				{
					_sounds[i] = null;
					_sounds.splice(i, 1);
				}
			}
			
			delete _soundsDict[$name];
		}
		
		
		
		/**
		 * Removes all sounds from the sound dictionary.
		 * 
		 * @return void
		 */
		public function removeAllSounds():void
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				_sounds[i] = null;
			}
			
			_sounds = new Array();
			_soundsDict = new Dictionary(true);
		}
		
		
		
		/**
		 * Plays or resumes a sound from the sound dictionary with the specified name.
		 * 
		 * @param $name The string identifier of the sound to play
		 * @param $volume A number from 0 to 1 representing the volume at which to play the sound (default: 1)
		 * @param $startTime A number (in milliseconds) representing the time to start playing the sound at (default: 0)
		 * @param $loops An integer representing the number of times to loop the sound (default: 0)
		 * 
		 * @return void
		 */
		public function playSound($name:String, $volume:Number = 1, $startTime:Number = 0, $loops:int = 0, $useGlobalVolume:Boolean = true, $fireEvent:Boolean = true):void
		{
			var snd:Object = _soundsDict[$name];
			
			
			if ( snd != null )
			{
				snd.volume = $volume;
				snd.startTime = $startTime;
				snd.loops = $loops;			
				
				var volume:Number = ($useGlobalVolume == true) ? _globalVolume : snd.volume;
				
				if (snd.paused)
				{
					snd.channel = snd.sound.play(snd.position, snd.loops, new SoundTransform(volume));
					if($fireEvent) snd.channel.addEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
				}
				else
				{				
					snd.channel = snd.sound.play($startTime, snd.loops, new SoundTransform(volume));
					if($fireEvent) snd.channel.addEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
					
				}
				
				snd.paused = false;
			}
		}
		
		
		
		/**
		 * Stops the specified sound.
		 * 
		 * @param $name The string identifier of the sound
		 * 
		 * @return void
		 */
		public function stopSound($name:String):void
		{
			var snd:Object = _soundsDict[$name];

			if(snd != null)
			{
				snd.paused = true;
				snd.channel.stop();
				snd.position = snd.channel.position;
			}
		}
		
		
		
		/**
		 * Pauses the specified sound.
		 * 
		 * @param $name The string identifier of the sound
		 * 
		 * @return void
		 */
		public function pauseSound($name:String):void
		{
			var snd:Object = _soundsDict[$name];
			snd.paused = true;
			snd.position = snd.channel.position;
			snd.channel.stop();
		}
		
		
		
		/**
		 * Plays all the sounds that are in the sound dictionary.
		 * 
		 * @param $useCurrentlyPlayingOnly A boolean that only plays the sounds which were currently playing before a pauseAllSounds() or stopAllSounds() call (default: false)
		 * 
		 * @return void
		 */
		public function playAllSounds($useCurrentlyPlayingOnly:Boolean = false):void
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				var id:String = _sounds[i].name;
				
				if ($useCurrentlyPlayingOnly)
				{
					if (_soundsDict[id].pausedByAll)
					{
						_soundsDict[id].pausedByAll = false;
						playSound(id);
					}
				}
				else
				{
					playSound(id);
				}
			}
		}
		
		
		
		/**
		 * Stops all the sounds that are in the sound dictionary.
		 * 
		 * @param $useCurrentlyPlayingOnly A boolean that only stops the sounds which are currently playing (default: true)
		 * 
		 * @return void
		 */
		public function stopAllSounds($useCurrentlyPlayingOnly:Boolean = true):void
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				var id:String = _sounds[i].name;
				
				if ($useCurrentlyPlayingOnly)
				{
					if (!_soundsDict[id].paused)
					{
						_soundsDict[id].pausedByAll = true;
						stopSound(id);
					}
				}
				else
				{
					stopSound(id);
				}
			}
		}
		
		
		
		/**
		 * Pauses all the sounds that are in the sound dictionary.
		 * 
		 * @param $useCurrentlyPlayingOnly A boolean that only pauses the sounds which are currently playing (default: true)
		 * 
		 * @return void
		 */
		public function pauseAllSounds($useCurrentlyPlayingOnly:Boolean = true):void
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				var id:String = _sounds[i].name;
				
				if ($useCurrentlyPlayingOnly)
				{
					if (!_soundsDict[id].paused)
					{
						_soundsDict[id].pausedByAll = true;
						pauseSound(id);
					}
				}
				else
				{
					pauseSound(id);
				}
			}
		}
		
		
		
		/**
		 * Fades the sound to the specified volume over the specified amount of time.
		 * 
		 * @param $name The string identifier of the sound
		 * @param $targVolume The target volume to fade to, between 0 and 1 (default: 0)
		 * @param $fadeLength The time to fade over, in seconds (default: 1)
		 * 
		 * @return void
		 */
		public function fadeSound($name:String, $targVolume:Number = 0, $fadeLength:Number = 1):void
		{
			var fadeChannel:SoundChannel = _soundsDict[$name].channel;

			TweenLite.to(fadeChannel, $fadeLength, {volume: $targVolume});
		}
		
		
		
		/**
		 * Added by A51 to stop all sounds one faded
		 */ 
		public function fadeSoundToStop($name:String, $fadeLength:Number = 1):void
		{
			var fadeChannel:SoundChannel = _soundsDict[$name].channel;
			
			TweenLite.to(fadeChannel, $fadeLength, {volume: 0, onComplete: stopSound, onCompleteParams: [$name] });
		}
		
		
		
		/**
		 * Mutes the volume for all sounds in the sound dictionary.
		 * 
		 * @return void
		 */
		public function muteAllSounds():void
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				var id:String = _sounds[i].name;
				
				setSoundVolume(id, 0);
			}
			
			_globalVolume = 0;
		}
		
		
		
		/**
		 * Fades all of the sounds in the sound dictionary to a specified volume
		 * 
		 * @param	$targVolume
		 * @param	$fadeLength
		 */
		public function fadeAllSounds($targVolume:Number = 0, $fadeLength:Number = 1):void
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				var sound:String = _sounds[i].name;
				fadeSound(sound, $targVolume, $fadeLength);
			}
		}
		
		
		
		/**
		 * Resets the volume to their original setting for all sounds in the sound dictionary.
		 * 
		 * @return void
		 */
		public function unmuteAllSounds():void
		{
			for (var i:int = 0; i < _sounds.length; i++)
			{
				var id			:String = _sounds[i].name,
					snd			:Object = _soundsDict[id],
					curTransform:SoundTransform = snd.channel.soundTransform;
				
				curTransform.volume = snd.volume;
				snd.channel.soundTransform = curTransform;
			}
			
			_globalVolume = 1;
		}
		
		
		
		/**
		 * Sets the volume of the specified sound.
		 * 
		 * @param $name The string identifier of the sound
		 * @param $volume The volume, between 0 and 1, to set the sound to
		 * 
		 * @return void
		 */
		public function setSoundVolume($name:String, $volume:Number):void
		{
			var snd			:Object = _soundsDict[$name],
				curTransform:SoundTransform = snd.channel.soundTransform;
			curTransform.volume = $volume;
			snd.channel.soundTransform = curTransform;
		}
		
		
		
		/**
		 * Gets the volume of the specified sound.
		 * 
		 * @param $name The string identifier of the sound
		 * 
		 * @return Number The current volume of the sound
		 */
		public function getSoundVolume($name:String):Number
		{
			return _soundsDict[$name].channel.soundTransform.volume;
		}
		
		
		
		/**
		 * Gets the position of the specified sound.
		 * 
		 * @param $name The string identifier of the sound
		 * 
		 * @return Number The current position of the sound, in milliseconds
		 */
		public function getSoundPosition($name:String):Number
		{
			return _soundsDict[$name].channel.position;
		}
		
		
		
		/**
		 * Gets the duration of the specified sound.
		 * 
		 * @param $name The string identifier of the sound
		 * 
		 * @return Number The length of the sound, in milliseconds
		 */
		public function getSoundDuration($name:String):Number
		{
			return _soundsDict[$name].sound.length;
		}
		
		
		
		/**
		 * Gets the sound object of the specified sound.
		 * 
		 * @param $name The string identifier of the sound
		 * 
		 * @return Sound The sound object
		 */
		public function getSoundObject($name:String):Sound
		{
			return _soundsDict[$name].sound;
		}
		
		
		
		/**
		 * Identifies if the sound is paused or not.
		 * 
		 * @param $name The string identifier of the sound
		 * 
		 * @return Boolean The boolean value of paused or not paused
		 */
		public function isSoundPaused($name:String):Boolean
		{
			return _soundsDict[$name].paused;
		}
		
		
		
		/**
		 * Identifies if the sound was paused or stopped by calling the stopAllSounds() or pauseAllSounds() methods.
		 * 
		 * @param $name The string identifier of the sound
		 * 
		 * @return Number The boolean value of pausedByAll or not pausedByAll
		 */
		public function isSoundPausedByAll($name:String):Boolean
		{
			return _soundsDict[$name].pausedByAll;
		}
		
		
		
		/**
		 * Helper
		 */	
		public override function toString():String
		{
			return getQualifiedClassName(this);
		}
		
		
		
		//--------------------------------------------------------------------------
		//  GETTERS & SETTERS
		//--------------------------------------------------------------------------
		
		public function get sounds():Array { return _sounds; }
		
		public function get volume():Number { return _globalVolume; }
		public function set volume(value:Number):void 
		{
			_globalVolume = value;
			fadeAllSounds( _globalVolume );
		}
	}
}