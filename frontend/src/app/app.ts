import { Component, OnInit } from '@angular/core';
import { RouterLink, RouterOutlet, Router, NavigationEnd } from '@angular/router';
import { NzIconModule } from 'ng-zorro-antd/icon';
import { NzLayoutModule } from 'ng-zorro-antd/layout';
import { NzMenuModule } from 'ng-zorro-antd/menu';
import { NzButtonModule } from 'ng-zorro-antd/button';
import { NzMessageService } from 'ng-zorro-antd/message';
import { AuthService } from './services/auth.service';
import { filter } from 'rxjs/operators';

@Component({
  selector: 'app-root',
  imports: [RouterLink, RouterOutlet, NzIconModule, NzLayoutModule, NzMenuModule, NzButtonModule],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App implements OnInit {
  isCollapsed = false;
  currentUser: any = null;
  
  // 菜单展开状态
  systemManagementOpen = false;
  personalCenterOpen = false;

  constructor(
    private authService: AuthService,
    private router: Router,
    private message: NzMessageService
  ) {}

  ngOnInit(): void {
    this.loadCurrentUser();
    this.setupMenuExpansion();
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

  /**
   * 设置菜单展开逻辑
   */
  private setupMenuExpansion(): void {
    // 监听路由变化
    this.router.events
      .pipe(filter(event => event instanceof NavigationEnd))
      .subscribe((event: NavigationEnd) => {
        this.updateMenuExpansion(event.url);
      });

    // 初始化时设置菜单状态
    this.updateMenuExpansion(this.router.url);
  }

  /**
   * 根据当前URL更新菜单展开状态
   */
  private updateMenuExpansion(url: string): void {
    // 重置所有菜单状态
    this.systemManagementOpen = false;
    this.personalCenterOpen = false;

    // 根据URL路径设置对应的菜单展开
    if (url.startsWith('/users') || url.startsWith('/roles') || 
        url.startsWith('/permissions') || url.startsWith('/departments') || 
        url.startsWith('/user-departments')) {
      this.systemManagementOpen = true;
    } else if (url.startsWith('/profile') || url.startsWith('/settings')) {
      this.personalCenterOpen = true;
    }
  }
}
