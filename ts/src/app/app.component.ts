import {Component, ElementRef, ViewChild, Renderer2} from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  @ViewChild("viewmore") MySpan!: ElementRef;

  title = 'DevChuva';
  linkText: string = "PT, BR";
  removerClasse: boolean = true;
  adicionarClasse: boolean = false;
  exibirFormulario: boolean = true;
  hidden_topic_button: boolean = false;
  sucessMessage: boolean = true;
  feedBack: boolean = true;
  isClicked: boolean = false;
  isClicked2: boolean = false;
  expandBool: boolean = true;
  expandBool2: boolean = false;

  changeText1() {
    this.linkText = "PT, BR";
  }

  changeText2() {
    this.linkText = "EN, US";
  }

  changeText3() {
    this.linkText = "ES, ES";
  }

  toggleClasse() {
    this.removerClasse = !this.removerClasse;

    if (!this.adicionarClasse) {
      this.adicionarClasse = !this.removerClasse;
    } else {
      this.adicionarClasse = !this.removerClasse;
    }
  }

  createTopic() {
    this.exibirFormulario = !this.exibirFormulario;
    if (!this.hidden_topic_button) {
      this.hidden_topic_button = true;
    } else {
      this.hidden_topic_button = false;
    }
  }

  Submit() {
    this.exibirFormulario = !this.exibirFormulario;
    this.sucessMessage = !this.sucessMessage;
    this.feedBack = !this.feedBack;
  }

  createNewTopic() {
    this.exibirFormulario = !this.exibirFormulario;
    if (!this.sucessMessage) {
      this.sucessMessage = true;
      this.feedBack = true;
    }

  }


  toggleClicked() {
    this.isClicked = !this.isClicked;
  }

  toggleClicked2() {
    this.isClicked2 = !this.isClicked2;
  }

  expandFun() {
    this.expandBool = !this.expandBool;
    if (!this.expandBool2) {
      this.expandBool2 = true;
    } else {
      this.expandBool2 = false;
    }
  }
}
