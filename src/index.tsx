import { requireNativeComponent, ViewStyle } from 'react-native';
import { UIManager, findNodeHandle } from "react-native";
import React, { Component } from 'react';

class MediaAvPlayer extends Component<MediaplayerAvplayerPropsType> {
  constructor(props: any) {
    super(props);
  }
  ref: any;
  play = () => {
    this._sendCommand(UIManager.getViewManagerConfig("MediaplayerAvplayerView").Commands.play, []);
  }
  pause = () => {
    this._sendCommand(UIManager.getViewManagerConfig("MediaplayerAvplayerView").Commands.pause, []);
  }
  stop = () => {
    this._sendCommand(UIManager.getViewManagerConfig("MediaplayerAvplayerView").Commands.stop, []);
  }
  seekTo = (position: number) => {
    this._sendCommand(UIManager.getViewManagerConfig("MediaplayerAvplayerView").Commands.seekTo, [position]);
  }
  setUrl = (url: string) => {
    console.log(url);
    this._sendCommand(UIManager.getViewManagerConfig("MediaplayerAvplayerView").Commands.setUrl, [url]);
  }

  _sendCommand(command: number, args: Array<any>) {
    UIManager.dispatchViewManagerCommand(
      findNodeHandle(this.ref),
      command,
      args
    )
  }
  render() {
    return (
      <MediaplayerAvplayerViewManager ref={(el) => this.ref = el} {...this.props} />
    )
  }
}

interface PlayerConfig {
  url?: string;
  repeat?: boolean;
  mute?: boolean;
  autostart?: boolean;
}

type MediaplayerAvplayerPropsType = {
  style?: ViewStyle;
  playerConfig?: PlayerConfig;
  play?: Function;
  pause?: Function;
  stop?: Function;
  seekTo?: Function;
  setUrl?: Function;
};

const MediaplayerAvplayerViewManager = requireNativeComponent<MediaplayerAvplayerPropsType>('MediaplayerAvplayerView');

export default MediaAvPlayer;
