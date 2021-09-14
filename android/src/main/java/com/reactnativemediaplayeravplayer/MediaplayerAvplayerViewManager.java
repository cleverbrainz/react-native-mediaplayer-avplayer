package com.reactnativemediaplayeravplayer;

import android.annotation.SuppressLint;
import android.graphics.Color;
import android.media.DeniedByServerException;
import android.media.MediaDrm;
import android.media.MediaPlayer;
import android.media.ResourceBusyException;
import android.media.UnsupportedSchemeException;
import android.os.Build;
import android.util.Log;
import android.view.View;
import android.view.SurfaceHolder;
import android.widget.VideoView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.uimanager.events.RCTEventEmitter;

import java.io.IOException;
import java.net.URI;
import java.util.Map;

public class MediaplayerAvplayerViewManager extends SimpleViewManager<VideoView> {
  public static final String REACT_CLASS = "MediaplayerAvplayerView";
  private static final int COMMAND_PLAY = 1;
  private static final int COMMAND_PAUSE = 2;
  private static final int COMMAND_STOP = 3;
  private static final int COMMAND_SEEK_TO = 4;
  private static final int COMMAND_SET_URL = 5;

  private MediaPlayer mMediaPlayer;
  private MediaPlayer.OnDrmInfoListener onDrmInfoListener;
  private String url;
  private Boolean repeat;
  private Boolean mute;
  private Boolean autostart;

  @Override
  @NonNull
  public String getName() {
    return REACT_CLASS;
  }

  @Override
  @NonNull
  public VideoView createViewInstance(ThemedReactContext reactContext) {
    return new VideoView(reactContext.getCurrentActivity());
  }

  @ReactProp(name = "playerConfig")
  public void setConfig(VideoView view, ReadableMap playerConfig) {
    url = playerConfig.getString("url");
    repeat = !playerConfig.hasKey("repeat") || playerConfig.getBoolean("repeat");
    autostart = playerConfig.hasKey("autostart") && playerConfig.getBoolean("autostart");
    mute = !playerConfig.hasKey("mute") || playerConfig.getBoolean("mute");

    setupPlayer(view);
  }

  private void setupPlayer(VideoView view) {
    mMediaPlayer = new MediaPlayer();
    if (repeat) {
      mMediaPlayer.setLooping(true);
    }

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      onDrmInfoListener = (mediaPlayer, drmInfo) -> {
        try {
          mediaPlayer.prepareDrm(drmInfo.getSupportedSchemes()[0]);
          byte[] data = mediaPlayer.getKeyRequest(null, null, null, MediaDrm.KEY_TYPE_STREAMING, null).getData();
          mediaPlayer.provideKeyResponse(null, data);
        } catch (@SuppressLint({"NewApi", "LocalSuppress"}) MediaPlayer.ProvisioningNetworkErrorException | MediaPlayer.ProvisioningServerErrorException | ResourceBusyException | UnsupportedSchemeException | DeniedByServerException | MediaPlayer.NoDrmSchemeException e) {
          e.printStackTrace();
        }
      };
      mMediaPlayer.setOnDrmInfoListener(onDrmInfoListener);
    }
    mMediaPlayer.setOnPreparedListener(mediaPlayer -> {
      if (autostart) {
        mediaPlayer.start();
      }
    });

    view.getHolder().addCallback(new SurfaceHolder.Callback() {
      @Override
      public void surfaceCreated(@NonNull SurfaceHolder surfaceHolder) {
        if (!mMediaPlayer.isPlaying()) {
            try {
                mMediaPlayer.setDataSource(url);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        mMediaPlayer.setDisplay(surfaceHolder);
        if (!mMediaPlayer.isPlaying()) {
            mMediaPlayer.prepareAsync();
        }
      }
      @Override
      public void surfaceChanged(@NonNull SurfaceHolder surfaceHolder, int i, int i1, int i2) {
      }
      @Override
      public void surfaceDestroyed(@NonNull SurfaceHolder surfaceHolder) {
      }
    });
  }

  @Nullable
  @Override
  public Map<String, Integer> getCommandsMap() {
    return MapBuilder.of(
      "play", COMMAND_PLAY,
      "pause", COMMAND_PAUSE,
      "stop", COMMAND_STOP,
      "seekTo", COMMAND_SEEK_TO,
      "setUrl", COMMAND_SET_URL);
  }

  @Override
  public void receiveCommand(@NonNull VideoView root, int commandId, @Nullable ReadableArray args) {
    super.receiveCommand(root, commandId, args);
    switch (commandId) {
      case COMMAND_PLAY:
        mMediaPlayer.start();
        break;
      case COMMAND_PAUSE:
        mMediaPlayer.pause();
        break;
      case COMMAND_STOP:
        mMediaPlayer.stop();
        break;
      case COMMAND_SEEK_TO:
        mMediaPlayer.seekTo(args.getInt(0));
        break;
      case COMMAND_SET_URL:
        url = args.getString(0);
        if (mMediaPlayer != null) {
            try {
                mMediaPlayer.release();
                mMediaPlayer = null;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        mMediaPlayer = new MediaPlayer();
        if (repeat) {
          mMediaPlayer.setLooping(true);
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            mMediaPlayer.setOnDrmInfoListener(onDrmInfoListener);
        }
        mMediaPlayer.setOnPreparedListener(mediaPlayer -> {
            if (autostart) {
              mediaPlayer.start();
            }
        });
        try {
            mMediaPlayer.setDataSource(url);
        } catch (IOException e) {
            e.printStackTrace();
        }
        mMediaPlayer.setDisplay(root.getHolder());
        mMediaPlayer.prepareAsync();
        try {
          mMediaPlayer.setDataSource(args.getString(0));
        } catch (IOException e) {
          e.printStackTrace();
        }
        break;
      default:{
      }
    }
  }
}
