import { requireNativeComponent, ViewStyle } from 'react-native';

type MediaplayerAvplayerProps = {
  color: string;
  style: ViewStyle;
};

export const MediaplayerAvplayerViewManager = requireNativeComponent<MediaplayerAvplayerProps>(
'MediaplayerAvplayerView'
);

export default MediaplayerAvplayerViewManager;
