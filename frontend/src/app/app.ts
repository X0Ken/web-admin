import { Component, OnInit } from '@angular/core';
import { RouterLink, RouterOutlet, Router } from '@angular/router';
import { NzIconModule } from 'ng-zorro-antd/icon';
import { NzLayoutModule } from 'ng-zorro-antd/layout';
import { NzMenuModule } from 'ng-zorro-antd/menu';
import { NzButtonModule } from 'ng-zorro-antd/button';
import { NzMessageService } from 'ng-zorro-antd/message';
import { AuthService } from './services/auth.service';

@Component({
  selector: 'app-root',
  imports: [RouterLink, RouterOutlet, NzIconModule, NzLayoutModule, NzMenuModule, NzButtonModule],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App implements OnInit {
  isCollapsed = false;
  currentUser: any = null;

  constructor(
    private authService: AuthService,
    private router: Router,
    private message: NzMessageService
  ) {}

  ngOnInit(): void {
    this.loadCurrentUser();
  }

  loadCurrentUser(): void {
    if (this.authService.isAuthenticated()) {
      this.authService.getCurrentUser().subscribe({
        next: (response) => {
          this.currentUser = response.user;
        },
        error: (error) => {
          console.error('获取用户信息失败:', error);
        }
      });
    }
  }

  logout(): void {
    this.authService.logout();
    this.message.success('已退出登录');
    this.router.navigate(['/login']);
  }
}
