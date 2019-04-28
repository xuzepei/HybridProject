import React, {Component} from "react";
import {AppRegistry, StyleSheet, Text, View, Image, Button, Alert, NativeModules, NativeEventEmitter} from 'react-native';

const { RNEventManager } = NativeModules;
const eventEmitter = new NativeEventEmitter(RNEventManager);
var eventListener = null;

class RNSubscriptionView extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
        button_title : "Button",
    };

  }

  componentWillMount() {

      this.eventListener = eventEmitter.addListener('onTestEvent', this.onTestEvent.bind(this));

  }

  componentWillUnmount() {

      this.eventListener.remove();
  }

  onTestEvent(body) {

      Alert.alert(body.body);

  }

  remove(data) {

      Alert.alert(data.msg);

  }

  clickedButton = () => {
    {/*Alert.alert('Button has been pressed!');*/}

    //call oc method
    NativeModules. RNEventManager.showAlert('Hello');

    NativeModules. RNEventManager.test('testtest').then(msg => {
                                   //msg就是你用resolve返回的值

                                   if(msg.name){
                                    Alert.alert(msg.name);
                                   } else {
                                    Alert.alert(msg.msg);
                                   }

                                }).catch(error => {
                                    //error就是你用reject返回的值

                                    Alert.alert(error.toString());
                                });

    this.setState({
                    button_title: "MyButton",
                });


  };

  render() {

    return (
      <View style={styles.container}>
        <Text style={styles.title}>{this.props.title}</Text>
        <Image source={require('./images/test.png')} style={styles.image}/>
          <Button
              onPress={this.clickedButton.bind(this)}
              title={this.state.button_title}
              color="#841584"
              accessibilityLabel=""
          />
      </View>
    );

  }
}



const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#FFFFFF',
  },
  title: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  image: {
    justifyContent: 'center',
    alignItems: 'center',
    width: 100,
    height: 100,
    backgroundColor: '#0000FF'
  },
});


AppRegistry.registerComponent('RNSubscriptionView', () => RNSubscriptionView);
