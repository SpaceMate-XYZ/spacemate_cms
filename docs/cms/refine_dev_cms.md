# Refine.dev CMS Admin Panel

## Overview

The Refine.dev CMS admin panel provides a comprehensive content management interface for SpaceMate CMS, allowing administrators to create, edit, and manage place-specific content including menus, onboarding carousels, and images.

## Architecture

### Component Structure
```
admin/
├── src/
│   ├── components/          # Reusable UI components
│   │   ├── PlaceForm/      # Place creation/editing form
│   │   ├── MenuEditor/     # Menu content editor
│   │   ├── OnboardingEditor/ # Onboarding carousel editor
│   │   └── ImageUploader/  # Image upload component
│   ├── pages/              # Admin pages
│   │   ├── places/         # Place management
│   │   ├── menus/          # Menu content
│   │   └── onboarding/     # Onboarding content
│   ├── resources/          # API resource definitions
│   ├── providers/          # Data providers
│   └── utils/              # Utility functions
├── public/                 # Static assets
└── package.json           # Dependencies
```

## Setup & Installation

### Prerequisites
- Node.js (18+)
- npm or yarn
- Access to NestJS API
- MinIO storage access

### Installation
```bash
# Clone the admin panel
cd admin

# Install dependencies
npm install

# Set up environment variables
cp .env.example .env
```

### Environment Configuration
```env
# API Configuration
REACT_APP_API_URL=http://localhost:3000
REACT_APP_MINIO_ENDPOINT=http://localhost:9000
REACT_APP_CLOUDINARY_CLOUD_NAME=your-cloud-name

# Authentication
REACT_APP_AUTH_PROVIDER=local
REACT_APP_LOGIN_URL=/login

# Feature Flags
REACT_APP_ENABLE_IMAGE_UPLOAD=true
REACT_APP_ENABLE_BULK_OPERATIONS=true
```

## Dependencies

### Core Refine.dev Dependencies
```json
{
  "@refinedev/core": "^4.45.0",
  "@refinedev/react-hook-form": "^4.8.0",
  "@refinedev/antd": "^5.35.0",
  "@refinedev/react-router-v6": "^4.5.0",
  "@refinedev/simple-rest": "^2.1.0"
}
```

### UI Components
```json
{
  "antd": "^5.12.8",
  "@ant-design/icons": "^5.2.6",
  "react-hook-form": "^7.48.2",
  "react-query": "^3.39.3"
}
```

### Image Handling
```json
{
  "react-dropzone": "^14.2.3",
  "react-image-crop": "^10.1.8",
  "file-saver": "^2.0.5"
}
```

## Components

### Place Form Component

```typescript
// components/PlaceForm/PlaceForm.tsx
import React from 'react';
import { useForm } from '@refinedev/react-hook-form';
import { Form, Input, Button, Card, Space } from 'antd';
import { MenuEditor } from '../MenuEditor/MenuEditor';
import { OnboardingEditor } from '../OnboardingEditor/OnboardingEditor';
import { ImageUploader } from '../ImageUploader/ImageUploader';

interface PlaceFormProps {
  initialValues?: PlaceFormData;
  onSave: (data: PlaceFormData) => void;
}

export const PlaceForm: React.FC<PlaceFormProps> = ({ 
  initialValues, 
  onSave 
}) => {
  const { formProps, saveButtonProps } = useForm({
    resource: "places",
    action: initialValues ? "edit" : "create",
    initialValues,
  });

  return (
    <Card title="Place Management">
      <Form {...formProps} layout="vertical">
        <Form.Item label="Place ID" name="placeId" rules={[{ required: true }]}>
          <Input placeholder="e.g., place-001" />
        </Form.Item>
        
        <Form.Item label="Place Name" name="name" rules={[{ required: true }]}>
          <Input placeholder="e.g., Downtown Office Building" />
        </Form.Item>
        
        <Form.Item label="Description" name="description">
          <Input.TextArea rows={3} placeholder="Place description..." />
        </Form.Item>
        
        <Form.Item label="Location" name="location">
          <Input placeholder="e.g., 123 Main St, City, State" />
        </Form.Item>
        
        <Form.Item label="Menus" name="menus">
          <MenuEditor />
        </Form.Item>
        
        <Form.Item label="Onboarding Content" name="onboarding">
          <OnboardingEditor />
        </Form.Item>
        
        <Form.Item label="Images" name="images">
          <ImageUploader />
        </Form.Item>
        
        <Form.Item>
          <Space>
            <Button type="primary" {...saveButtonProps}>
              Save Place
            </Button>
            <Button>Cancel</Button>
          </Space>
        </Form.Item>
      </Form>
    </Card>
  );
};
```

### Menu Editor Component

```typescript
// components/MenuEditor/MenuEditor.tsx
import React, { useState } from 'react';
import { Card, Button, List, Form, Input, Switch, Space, Popconfirm } from 'antd';
import { PlusOutlined, DeleteOutlined, EditOutlined } from '@ant-design/icons';
import { ScreenEditor } from './ScreenEditor';

interface MenuEditorProps {
  value?: MenuFormData;
  onChange?: (value: MenuFormData) => void;
}

export const MenuEditor: React.FC<MenuEditorProps> = ({ value, onChange }) => {
  const [screens, setScreens] = useState<ScreenFormData[]>(value?.screens || []);

  const addScreen = () => {
    const newScreen: ScreenFormData = {
      slug: '',
      label: '',
      icon: 'home',
      order: screens.length + 1,
      isVisible: true,
      isAvailable: true,
      badgeCount: 0,
      features: []
    };
    
    const updatedScreens = [...screens, newScreen];
    setScreens(updatedScreens);
    onChange?.({ screens: updatedScreens });
  };

  const updateScreen = (index: number, screen: ScreenFormData) => {
    const updatedScreens = [...screens];
    updatedScreens[index] = screen;
    setScreens(updatedScreens);
    onChange?.({ screens: updatedScreens });
  };

  const deleteScreen = (index: number) => {
    const updatedScreens = screens.filter((_, i) => i !== index);
    setScreens(updatedScreens);
    onChange?.({ screens: updatedScreens });
  };

  return (
    <Card title="Menu Screens" extra={<Button icon={<PlusOutlined />} onClick={addScreen}>Add Screen</Button>}>
      <List
        dataSource={screens}
        renderItem={(screen, index) => (
          <List.Item
            actions={[
              <EditOutlined key="edit" onClick={() => setEditingIndex(index)} />,
              <Popconfirm
                title="Delete this screen?"
                onConfirm={() => deleteScreen(index)}
              >
                <DeleteOutlined key="delete" style={{ color: 'red' }} />
              </Popconfirm>
            ]}
          >
            <ScreenEditor
              value={screen}
              onChange={(updatedScreen) => updateScreen(index, updatedScreen)}
            />
          </List.Item>
        )}
      />
    </Card>
  );
};
```

### Onboarding Editor Component

```typescript
// components/OnboardingEditor/OnboardingEditor.tsx
import React, { useState } from 'react';
import { Card, Select, Button, List, Space } from 'antd';
import { PlusOutlined } from '@ant-design/icons';
import { SlideEditor } from './SlideEditor';

const { Option } = Select;

interface OnboardingEditorProps {
  value?: OnboardingFormData;
  onChange?: (value: OnboardingFormData) => void;
}

const FEATURE_OPTIONS = [
  { value: 'parking', label: 'Parking' },
  { value: 'valetparking', label: 'Valet Parking' },
  { value: 'meeting', label: 'Meeting Rooms' },
  { value: 'facilities', label: 'Facilities' },
  { value: 'transport', label: 'Transport' },
  { value: 'access', label: 'Access Control' }
];

export const OnboardingEditor: React.FC<OnboardingEditorProps> = ({ 
  value, 
  onChange 
}) => {
  const [selectedFeature, setSelectedFeature] = useState<string>('');
  const [onboardingData, setOnboardingData] = useState<OnboardingFormData>(
    value || {}
  );

  const addFeature = () => {
    if (selectedFeature && !onboardingData[selectedFeature]) {
      const updatedData = {
        ...onboardingData,
        [selectedFeature]: []
      };
      setOnboardingData(updatedData);
      onChange?.(updatedData);
    }
  };

  const updateFeature = (featureName: string, slides: OnboardingSlideFormData[]) => {
    const updatedData = {
      ...onboardingData,
      [featureName]: slides
    };
    setOnboardingData(updatedData);
    onChange?.(updatedData);
  };

  return (
    <Card title="Onboarding Carousels">
      <Space direction="vertical" style={{ width: '100%' }}>
        <Space>
          <Select
            placeholder="Select feature"
            style={{ width: 200 }}
            onChange={setSelectedFeature}
          >
            {FEATURE_OPTIONS.map(option => (
              <Option key={option.value} value={option.value}>
                {option.label}
              </Option>
            ))}
          </Select>
          <Button 
            icon={<PlusOutlined />} 
            onClick={addFeature}
            disabled={!selectedFeature || !!onboardingData[selectedFeature]}
          >
            Add Feature
          </Button>
        </Space>

        {Object.entries(onboardingData).map(([featureName, slides]) => (
          <Card 
            key={featureName} 
            title={`${FEATURE_OPTIONS.find(f => f.value === featureName)?.label} Onboarding`}
            size="small"
          >
            <SlideEditor
              value={slides}
              onChange={(updatedSlides) => updateFeature(featureName, updatedSlides)}
            />
          </Card>
        ))}
      </Space>
    </Card>
  );
};
```

### Image Uploader Component

```typescript
// components/ImageUploader/ImageUploader.tsx
import React, { useCallback, useState } from 'react';
import { Upload, Card, List, Button, Progress, Space } from 'antd';
import { InboxOutlined, DeleteOutlined } from '@ant-design/icons';
import { useDropzone } from 'react-dropzone';
import { uploadToMinIO } from '../../utils/minio';

const { Dragger } = Upload;

interface ImageUploaderProps {
  value?: ImageFormData[];
  onChange?: (value: ImageFormData[]) => void;
}

export const ImageUploader: React.FC<ImageUploaderProps> = ({ 
  value = [], 
  onChange 
}) => {
  const [uploading, setUploading] = useState(false);
  const [uploadProgress, setUploadProgress] = useState<Record<string, number>>({});

  const onDrop = useCallback(async (acceptedFiles: File[]) => {
    setUploading(true);
    
    for (const file of acceptedFiles) {
      try {
        setUploadProgress(prev => ({ ...prev, [file.name]: 0 }));
        
        const uploadedImage = await uploadToMinIO(file, (progress) => {
          setUploadProgress(prev => ({ 
            ...prev, 
            [file.name]: progress 
          }));
        });

        const newImage: ImageFormData = {
          id: uploadedImage.id,
          file,
          url: uploadedImage.url,
          localPath: uploadedImage.localPath,
          size: file.size,
          width: uploadedImage.width,
          height: uploadedImage.height
        };

        onChange?.([...value, newImage]);
      } catch (error) {
        console.error('Upload failed:', error);
      }
    }
    
    setUploading(false);
    setUploadProgress({});
  }, [value, onChange]);

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    accept: {
      'image/*': ['.jpeg', '.jpg', '.png', '.gif', '.webp']
    },
    multiple: true
  });

  const removeImage = (imageId: string) => {
    const updatedImages = value.filter(img => img.id !== imageId);
    onChange?.(updatedImages);
  };

  return (
    <Card title="Image Management">
      <Space direction="vertical" style={{ width: '100%' }}>
        <div {...getRootProps()} style={{ 
          border: '2px dashed #d9d9d9',
          borderRadius: '6px',
          padding: '20px',
          textAlign: 'center',
          cursor: 'pointer'
        }}>
          <input {...getInputProps()} />
          <InboxOutlined style={{ fontSize: '48px', color: '#d9d9d9' }} />
          <p>{isDragActive ? 'Drop images here' : 'Drag & drop images or click to select'}</p>
        </div>

        {uploading && (
          <div>
            {Object.entries(uploadProgress).map(([fileName, progress]) => (
              <div key={fileName}>
                <span>{fileName}</span>
                <Progress percent={progress} size="small" />
              </div>
            ))}
          </div>
        )}

        <List
          dataSource={value}
          renderItem={(image) => (
            <List.Item
              actions={[
                <Button 
                  icon={<DeleteOutlined />} 
                  onClick={() => removeImage(image.id)}
                  danger
                />
              ]}
            >
              <List.Item.Meta
                avatar={<img src={image.url} alt={image.id} style={{ width: 50, height: 50, objectFit: 'cover' }} />}
                title={image.id}
                description={`${image.size} bytes`}
              />
            </List.Item>
          )}
        />
      </Space>
    </Card>
  );
};
```

## Pages

### Places List Page

```typescript
// pages/places/PlacesList.tsx
import React from 'react';
import { List, useTable, EditButton, DeleteButton, CreateButton } from '@refinedev/antd';
import { Table, Space, Tag } from 'antd';
import { EyeOutlined, EditOutlined, DeleteOutlined } from '@ant-design/icons';

export const PlacesList: React.FC = () => {
  const { tableProps } = useTable({
    resource: "places",
  });

  const columns = [
    {
      title: "Place ID",
      dataIndex: "placeId",
      key: "placeId",
    },
    {
      title: "Name",
      dataIndex: "name",
      key: "name",
    },
    {
      title: "Version",
      dataIndex: "version",
      key: "version",
      render: (version: string) => <Tag color="blue">{version}</Tag>,
    },
    {
      title: "Features",
      dataIndex: "features",
      key: "features",
      render: (features: string[]) => (
        <Space>
          {features.map(feature => (
            <Tag key={feature} color="green">{feature}</Tag>
          ))}
        </Space>
      ),
    },
    {
      title: "Last Updated",
      dataIndex: "lastUpdated",
      key: "lastUpdated",
      render: (date: string) => new Date(date).toLocaleDateString(),
    },
    {
      title: "Actions",
      key: "actions",
      render: (_, record: any) => (
        <Space>
          <EditButton icon={<EditOutlined />} recordItemId={record.id} />
          <DeleteButton icon={<DeleteOutlined />} recordItemId={record.id} />
        </Space>
      ),
    },
  ];

  return (
    <List
      headerButtons={<CreateButton />}
    >
      <Table {...tableProps} columns={columns} rowKey="id" />
    </List>
  );
};
```

### Place Edit Page

```typescript
// pages/places/PlaceEdit.tsx
import React from 'react';
import { Edit, useForm } from '@refinedev/antd';
import { PlaceForm } from '../../components/PlaceForm/PlaceForm';

export const PlaceEdit: React.FC = () => {
  const { formProps, saveButtonProps, queryResult } = useForm({
    resource: "places",
  });

  return (
    <Edit saveButtonProps={saveButtonProps}>
      <PlaceForm
        initialValues={queryResult?.data?.data}
        onSave={(data) => {
          // Handle save logic
          console.log('Saving place:', data);
        }}
      />
    </Edit>
  );
};
```

## Configuration

### Data Provider Setup

```typescript
// providers/dataProvider.ts
import { DataProvider } from '@refinedev/core';
import { simpleRestProvider } from '@refinedev/simple-rest';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:3000';

export const dataProvider: DataProvider = simpleRestProvider(API_URL, {
  // Customize data provider for MinIO integration
  getList: async ({ resource, pagination, filters, sorters }) => {
    const url = `${API_URL}/${resource}`;
    const response = await fetch(url);
    const data = await response.json();
    
    return {
      data: data.data || [],
      total: data.total || 0,
    };
  },
  
  create: async ({ resource, variables }) => {
    const url = `${API_URL}/${resource}`;
    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(variables),
    });
    
    return {
      data: await response.json(),
    };
  },
  
  update: async ({ resource, id, variables }) => {
    const url = `${API_URL}/${resource}/${id}`;
    const response = await fetch(url, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(variables),
    });
    
    return {
      data: await response.json(),
    };
  },
  
  deleteOne: async ({ resource, id }) => {
    const url = `${API_URL}/${resource}/${id}`;
    await fetch(url, {
      method: 'DELETE',
    });
    
    return {
      data: {},
    };
  },
});
```

### App Configuration

```typescript
// App.tsx
import React from 'react';
import { Refine } from '@refinedev/core';
import { RefineAntd } from '@refinedev/antd';
import { dataProvider } from './providers/dataProvider';
import { PlacesList } from './pages/places/PlacesList';
import { PlaceEdit } from './pages/places/PlaceEdit';
import { PlaceCreate } from './pages/places/PlaceCreate';

function App() {
  return (
    <Refine
      dataProvider={dataProvider}
      resources={[
        {
          name: "places",
          list: "/places",
          create: "/places/create",
          edit: "/places/edit/:id",
          show: "/places/show/:id",
        },
      ]}
      options={{
        syncWithLocation: true,
        warnWhenUnsavedChanges: true,
      }}
    >
      <RefineAntd>
        {/* Routes will be handled by React Router */}
      </RefineAntd>
    </Refine>
  );
}

export default App;
```

## Deployment

### Docker Configuration

```dockerfile
# Dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

RUN npm run build

EXPOSE 3000

CMD ["npm", "start"]
```

### Docker Compose

```yaml
# docker-compose.yml
services:
  refine-admin:
    build: ./admin
    ports:
      - "3001:3000"
    environment:
      - REACT_APP_API_URL=http://nestjs-api:3000
      - REACT_APP_MINIO_ENDPOINT=http://minio:9000
    depends_on:
      - nestjs-api
      - minio
```

## Testing

### Component Testing

```typescript
// components/PlaceForm/__tests__/PlaceForm.test.tsx
import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react';
import { PlaceForm } from '../PlaceForm';

describe('PlaceForm', () => {
  it('renders form fields correctly', () => {
    render(<PlaceForm onSave={() => {}} />);
    
    expect(screen.getByLabelText(/place id/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/place name/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/description/i)).toBeInTheDocument();
  });

  it('calls onSave with form data', () => {
    const mockOnSave = jest.fn();
    render(<PlaceForm onSave={mockOnSave} />);
    
    fireEvent.change(screen.getByLabelText(/place id/i), {
      target: { value: 'test-place-001' },
    });
    
    fireEvent.click(screen.getByText(/save place/i));
    
    expect(mockOnSave).toHaveBeenCalledWith(
      expect.objectContaining({
        placeId: 'test-place-001',
      })
    );
  });
});
```

## Monitoring

### Performance Monitoring

```typescript
// utils/monitoring.ts
export const trackEvent = (eventName: string, data?: any) => {
  // Send analytics data
  console.log('Event:', eventName, data);
};

export const trackError = (error: Error, context?: any) => {
  // Send error data to monitoring service
  console.error('Error:', error, context);
};
```

### Usage Analytics

```typescript
// hooks/useAnalytics.ts
import { useEffect } from 'react';
import { trackEvent } from '../utils/monitoring';

export const useAnalytics = (pageName: string) => {
  useEffect(() => {
    trackEvent('page_view', { page: pageName });
  }, [pageName]);
};
```

---

**This Refine.dev CMS admin panel provides a comprehensive content management interface for SpaceMate CMS, enabling efficient creation and management of place-specific content with a modern, user-friendly interface.** 