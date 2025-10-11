import { Routes } from '@angular/router';
import { AuthGuard } from './guards/auth.guard';

export const routes: Routes = [
  { path: '', pathMatch: 'full', redirectTo: '/login' },
  { path: 'login', loadChildren: () => import('./pages/login/login.routes').then(m => m.LOGIN_ROUTES) },
  {
    path: '',
    canActivate: [AuthGuard],
    children: [
      {
        path: 'welcome',
        loadChildren: () => import('./pages/welcome/welcome.routes').then(m => m.WELCOME_ROUTES)
      },
      {
        path: 'users',
        loadChildren: () => import('./pages/users/users.routes').then(m => m.USERS_ROUTES)
      },
      {
        path: 'roles',
        loadChildren: () => import('./pages/roles/roles.routes').then(m => m.ROLES_ROUTES)
      },
      {
        path: 'permissions',
        loadChildren: () => import('./pages/permissions/permissions.routes').then(m => m.PERMISSIONS_ROUTES)
      },
      {
        path: 'profile',
        loadChildren: () => import('./pages/profile/profile.routes').then(m => m.PROFILE_ROUTES)
      },
      {
        path: 'settings',
        loadChildren: () => import('./pages/settings/settings.routes').then(m => m.SETTINGS_ROUTES)
      },
      {
        path: 'departments',
        loadChildren: () => import('./pages/departments/departments.routes').then(m => m.DEPARTMENTS_ROUTES)
      },
      {
        path: 'user-departments',
        loadChildren: () => import('./pages/user-departments/user-departments.routes').then(m => m.USER_DEPARTMENTS_ROUTES)
      }
    ]
  }
];
