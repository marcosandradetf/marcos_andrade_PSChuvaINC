import {Component} from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  title = 'DevChuva';
  linkText: string = "PT, BR";

  changeText1() {
    this.linkText = "PT, BR";
  }

  changeText2() {
    this.linkText = "EN, US";
  }

  changeText3() {
    this.linkText = "ES, ES";
  }

}
