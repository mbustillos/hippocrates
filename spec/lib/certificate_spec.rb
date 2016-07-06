require 'rails_helper'

describe Certificate do
  describe '#build' do
    let(:start_time) { '' }
    let(:end_time) { '' }
    let(:consultation) { build(:consultation, :with_diagnoses, patient: patient) }
    let(:patient) do
      build(:patient, identity_card_number: 'icn-101',
                      first_name: 'Rene',
                      last_name: 'Brown',
                      gender: gender)
    end
    let(:certificate) do
      {
        definite_article: definite_article,
        patient_name: 'Brown Rene',
        identity_card_number: 'icn-101',
        disease: 'disease',
        disease_code: 'A01',
        current_date: '21 de Octubre de 2015',
        start_time: start_time,
        end_time: end_time
      }
    end

    context 'when patient is male' do
      let(:gender)           { 'male' }
      let(:definite_article) { 'el' }

      it 'builds certificate for male' do
        Timecop.freeze('2015-10-21') do
          expect(described_class.for(consultation).build).to eq(certificate)
        end
      end
    end

    context 'when patient is female' do
      let(:gender)           { 'female' }
      let(:definite_article) { 'la' }

      it 'builds certificate for female' do
        Timecop.freeze('2015-10-21') do
          expect(described_class.for(consultation).build).to eq(certificate)
        end
      end
    end

    context 'when time options are passed' do
      let(:start_time)       { '10:00 am' }
      let(:end_time)         { '11:30 am' }
      let(:gender)           { 'female' }
      let(:definite_article) { 'la' }

      it 'builds certificate with time info' do
        Timecop.freeze('2015-10-21') do
          options = { start_time: '10:00 am', end_time: '11:30 am' }
          expect(described_class.for(consultation, options).build).to eq(certificate)
        end
      end
    end
  end
end
