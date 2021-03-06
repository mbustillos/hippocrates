require 'rails_helper'

describe MedicinesController do
  before { sign_in_user_mock }

  describe '#index' do
    let(:medicines) { [create(:medicine)] }

    before do
      get :index
    end

    it 'assings @medicines' do
      expect(assigns(:medicines)).to eq(medicines)
    end

    it { is_expected.to render_template :index }
    it { is_expected.to respond_with :ok }
  end

  describe '#new' do
    before do
      get :new
    end

    it 'assings @medicine' do
      expect(assigns(:medicine)).to be_a_new(Medicine)
    end

    it { is_expected.to render_template :new }
    it { is_expected.to respond_with :ok }
  end

  describe '#create' do
    before do |example|
      unless example.metadata[:skip_on_before]
        post :create, params: { medicine: attributes_for_medicine }
      end
    end

    context 'when the information is complete' do
      let(:attributes_for_medicine) { attributes_for(:medicine) }

      it 'creates a medicine', :skip_on_before do
        expect do
          post :create, params: { medicine: attributes_for_medicine }
        end.to change { Medicine.count }.by(1)
      end

      it { is_expected.to redirect_to medicines_path }
      it { is_expected.to respond_with :redirect }
    end

    context 'when the information is incomplete' do
      let(:attributes_for_medicine) do
        attributes_for(:medicine).except(:instructions)
      end

      it 'does not create a medicine', :skip_on_before do
        expect do
          post :create, params: { medicine: attributes_for_medicine }
        end.to change { Medicine.count }.by(0)
      end

      it { is_expected.to render_template :new }
      it { is_expected.to respond_with :ok }
    end
  end

  describe '#edit' do
    let(:medicine) { double(:medicine) }

    before do
      allow(Medicine).to receive(:find).with('1') { medicine }
      get :edit, params: { id: '1' }
    end

    it 'assings @medicine' do
      expect(assigns(:medicine)).to eq(medicine)
    end

    it { is_expected.to render_template :edit }
    it { is_expected.to respond_with :ok }
  end

  describe '#update' do
    let(:medicine) { create(:medicine, name: 'paracetamol') }

    context 'when the information is valid' do
      before do
        patch :update, params: { id: medicine.id, medicine: { name: 'acetaminophen' } }
      end

      it 'updates the medicine' do
        medicine.reload
        expect(medicine.name).to eq('ACETAMINOPHEN')
      end

      it { is_expected.to redirect_to medicines_path }
      it { is_expected.to respond_with :redirect }
    end

    context 'when the information is invalid' do
      before { put :update, params: { id: medicine.id, medicine: { name: '' } } }

      it 'do not update the medicine' do
        medicine.reload
        expect(medicine.name).to eq('PARACETAMOL')
      end

      it { is_expected.to render_template :edit }
      it { is_expected.to respond_with :ok }
    end
  end

  describe '#destroy' do
    let!(:medicine) { create(:medicine) }

    before do |example|
      delete :destroy, params: { id: medicine.id } unless example.metadata[:skip_on_before]
    end

    it 'deletes the medicine', :skip_on_before do
      expect do
        delete :destroy, params: { id: medicine.id }
      end.to change { Medicine.count }.from(1).to(0)
    end

    it { is_expected.to redirect_to medicines_path }
  end
end
