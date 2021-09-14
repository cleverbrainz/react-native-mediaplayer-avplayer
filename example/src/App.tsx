import * as React from 'react';

import { Button, StyleSheet, View } from 'react-native';
import MediaAvPlayer from 'react-native-mediaplayer-avplayer';

export default function App() {
  const [ref, setRef] = React.useState<MediaAvPlayer | null>();
  return (
    <View style={styles.container}>
      <Button title="Change Url" onPress={() => {
        
        }} ></Button>
      <Button title="Change Url" onPress={() => { }} ></Button>
      <Button title="Change Url" onPress={() => {
        if (ref) {
          ref.pause();
        }
      }} ></Button>
      <Button title="Change Url" onPress={() => { 
        if (ref) {
          ref.setUrl("https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_1920_18MG.mp4")
        }
      }} ></Button>
      <MediaAvPlayer
        ref={p => setRef(p)}
        style={styles.box}
        playerConfig={{
          url: "http://66.42.96.108:8081/Sign_up_graphic.mp4",
          repeat: true,
          mute: false,
          autostart: true
        }}
        />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: "100%",
    height: "100%"
  },
});
